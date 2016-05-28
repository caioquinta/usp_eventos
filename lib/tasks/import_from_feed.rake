require 'rss'
require 'open-uri'

namespace :events do
  task :import_from_feed => :environment do
    ['inovacao-agencia-usp-inovacao', 'anfiteatro-das-colmeias', 'sala-do-conselho-universitario', 'arquivo-geral-da-usp', 'auditorio-do-conselho-universitario', 
     'biblioteca-brasiliana', 'casa-de-cultura-japonesa', 'casa-de-dona-yaya', 'cedir-centro-de-descarte-e-reuso-de-residuos-de-informatica', 'centro-de-apoio-e-pesquisa-em-pediatria-caepp', 
     'centro-de-difusao-internacional', 'centro-de-docencia-e-pesquisa-do-departamento-de-fisioterapia-fonoaudiologia-e-terapia-ocupacional', 'centro-de-estudos-amerindios-cesta', 
     'centro-de-estudos-latino-americanos-sobre-cultura-e-comunicacao-celacc', 'centro-de-informacoes-da-usp', 'centro-de-visitantes', 'centro-interdisciplinar-em-tecnologias-interativas-citi', 
     'centro-universitario-maria-antonia', 'cepe-centro-de-praticas-esportivas', 'cce-centro-de-computacao-eletronica', 'cientec-parque-de-ciencia-e-tecnologia-da-usp', 'cinusp-cinema-da-usp-paulo-emilio', 
     'cmu-eca', 'comix-book-shop', 'coseas-coordenadoria-de-assistencia-social', 'creche-e-pre-escola-central', 'crechepre-escola-oeste', 'crnutri-fsp-faculdade-de-saude-publica', 'cti-coordenadoria-de-tecnologia-da-informacao',
     'dti-departamento-de-tecnologia-da-informacao', 'each-escola-de-artes-ciencias-e-humanidades', 'eca-auditorio-olivier-toni', 'eca-conjunto-arquitetonico-das-artes', 'eca-escola-de-comunicacao-e-artes', 
     'eca-teatro-laboratorio-da-eca', 'edificio-brasiliana', 'edusp-editora-da-usp', 'ee-escola-de-enfermagem', 'eefe-escola-de-educacao-fisica-e-esporte', 'escola-de-aplicacao', 'escola-de-educacao-permanente-hcfmusp', 
     'espaco-agora-capital', 'espaco-cultural-porto-seguro', 'espaco-de-atividades-educativas', 'estacao-meteorologica-do-iag', 'expo-center-norte-capital', 'fapcom-faculdade-paulus-de-tecnologia-e-comunicacao', 
     'fau-faculdade-de-arquitetura-e-urbanismo', 'fau-maranhao-2', 'fcf-faculdade-de-ciencias-farmaceuticas', 'fd-faculdade-de-direito', 'fe-faculdade-de-educacao', 'fea-faculdade-de-economia-administracao-e-contabilidade', 
     'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-departamento-de-historia', 'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas', 'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-departamento-de-ciencia-politica', 
     'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-departamento-de-filosofia-e-ciencias-sociais', 'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-departamento-de-geografia', 
     'fflch-faculdade-de-filosofia-de-letras-e-ciencias-humanas-departamento-de-letras', 'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-cedhal', 'fm-faculdade-de-medicina', 'fmvz-faculdade-de-medicina-veterinaria-e-zootecnia', 
     'fo-faculdade-de-odontologia', 'fsp-faculdade-de-saude-publica', 'fupam-fundacao-para-a-pesquisa-em-arquitetura-e-ambiente', 'galpao-ponto-de-cultura-escola-da-rua', 'hospital-das-clinicas', 'hospital-das-clinicas-instituto-da-crianca',
     'hospital-universitario-hu', 'iag-instituto-de-astronomia-geofisica-e-ciencias-atmosfericas', 'ib-instituto-de-biociencias', 'icb-i-instituto-de-ciencias-biomedicas', 'icb-ii-instituto-de-ciencias-biomedicas', 'icb-iv-instituto-de-ciencias-biomedicas',
     'icb-instituto-de-ciencias-biomedicas', 'iea-institutos-de-estudos-avancados', 'ieb-instituto-de-estudos-brasileiros', 'iee-instituto-de-eletrotecnica-e-energia', 'if-instituto-de-fisica', 'igc-instituto-de-geociencias', 'ime-instituto-de-matematica-e-estatistica', 
     'imt-instituto-de-medicina-tropical-de-sao-paulo', 'inrad-instituto-de-radiologia-do-hc', 'instituto-central-do-hospital-das-clinicas', 'instituto-do-coracao-incor', 'io-instituto-oceanografico', 'ip-instituto-de-psicologia', 'ipen-2', 'ipq', 'iq-instituto-de-quimica', 
     'iri-instituto-de-relacoes-internacionais', 'laboratorio-de-sustentabilidade-lassu', 'lcca-laboratorio-de-computacao-cientifica-avancada', 'livraria-joao-alexandre-barbosa', 'mac-museu-de-arte-contemporanea', 'mac-usp-nova-sede', 'mae-museu-de-arqueologia-e-etnologia', 
     'mp-museu-paulista', 'nucleo-de-estudos-da-violencia-nev', 'nucel-nucleo-de-terapia-celular-e-molecular', 'nucleo-de-extensao-e-cultura-em-artes-afro-brasileiras', 'nucleo-dos-direitos-da-usp', 'nupps-nucleo-de-pesquisa-em-politicas-publicas', 'paco-das-artes', 
     'poli-administracao', 'poli-departamento-de-engenharia-de-producao', 'poli-departamento-de-engenharia-de-materiais', 'poli-departamento-de-engenharia-naval', 'poli-escola-politecnica', 'poli-laboratorio-de-sustentabilidade-lassu', 'praca-das-artes', 
     'praca-do-relogio-capital', 'prceu-pro-reitoria-de-cultura-e-extensao-universitaria', 'reitoria', 'cocesp-coordenadoria-do-campus-da-capital', 'prg-pro-reitoria-de-graduacao', 'prolam', 'prp-pro-reitoria-de-pesquisa', 'prpg-pro-reitoria-de-pos-graduacao', 
     'sibi-sistema-integrado-de-bibliotecas', 'sti-superintendencia-de-tecnologia-da-informacao', 'tenda-cultural-ortega-y-gasset-capital', 'tusp-teatro-da-usp'].each do | location | 

      url = 'http://www.eventos.usp.br/?campi-unidades='+location+'&feed=rss'
      admin = User.find_by name: 'USP EVENTOS'
      next_events = Event.next_events
      open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          if (item.pubDate >= Date.today.at_beginning_of_month) && (next_events.where(name: item.title).empty?)
            puts "Title: #{item.title}"
            Event.create name: item.title, planner: admin, description: item.description, location: location, begin_date: item.pubDate
          end
        end
      end
    end
  end
end
