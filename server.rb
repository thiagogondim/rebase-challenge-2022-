require 'sinatra'
require 'sinatra/reloader'
require 'rack/handler/puma'
require 'sidekiq'
require_relative './lib/db_manager'
require_relative './lib/clinical_exams'
require_relative './workers/import_worker'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0'}
end

class ClinicalExamsApi < Sinatra::Base
  configure :development, :production do
    register Sinatra::Reloader
  end

  set default_content_type: 'json'
  set :bind, '0.0.0.0'
  set :port, 3000

  get '/tests' do
    ClinicalExams.all_exams
  end

  get '/tests/:token' do
    ClinicalExams.show_exam(params["token"]).to_json
  end

  post '/import' do
    data = request.body.read.force_encoding('utf-8')

    return 412, '{ Por favor escolha o arquivo a ser enviado. }'.to_json if data.empty?

    ImportWorker.perform_async(data)
    status 200; body '{ Os exames estão sendo processados  }'.to_json 
  end

  run! if app_file == $0
end