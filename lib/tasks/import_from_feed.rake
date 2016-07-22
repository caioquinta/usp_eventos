require 'rss'
require 'open-uri'

namespace :events do
  task :import_from_feed => :environment do
    {'inovacao-agencia-usp-inovacao': 'Agência USP de Inovação', 'anfiteatro-das-colmeias': 'Anfiteatro das Colméias', 'sala-do-conselho-universitario': 'Sala do Conselho Universitário', 'lcca-laboratorio-de-computacao-cientifica-avancada': 'LCCA',
     'arquivo-geral-da-usp': 'Arquivo Geral da USP', 'auditorio-do-conselho-universitario': 'Auditório do Conselho Universitário', 'biblioteca-brasiliana': 'Biblioteca Brasiliana', 'mac-usp-nova-sede': 'Museu de Arte Conteporânea',
     'casa-de-cultura-japonesa': 'Casa de Cultura Japonesa', 'casa-de-dona-yaya': 'Casa de Cultura Dona Yaya', 'centro-de-apoio-e-pesquisa-em-pediatria-caepp': 'Centro de Apoio e pesquisa em Pediatria (CAEPP)', 'prolam': 'PROLAM',
     'centro-de-difusao-internacional': 'Centro de Difusão Internacional', 'centro-de-docencia-e-pesquisa-do-departamento-de-fisioterapia-fonoaudiologia-e-terapia-ocupacional': 'Centro de docencia e pesquisa da FOFITO', 
     'centro-de-estudos-amerindios-cesta': 'Centro de Estudos Ameríndio Cesta', 'centro-de-estudos-latino-americanos-sobre-cultura-e-comunicacao-celacc': 'CELACC', 'centro-de-informacoes-da-usp': 'Centro de Informações da USP', 
     'centro-de-visitantes': 'Centro de Visitantes', 'centro-interdisciplinar-em-tecnologias-interativas-citi': 'CITI - Centro Interdiscipinar em tecnlogias interativas', 'centro-universitario-maria-antonia': 'Centro Universitário Maria Antonia',
     'cepe-centro-de-praticas-esportivas': 'CEPE - USP', 'cce-centro-de-computacao-eletronica': 'CCE - Centro de Computação e Eletrônica', 'cientec-parque-de-ciencia-e-tecnologia-da-usp': 'CIENTEC', 'cinusp-cinema-da-usp-paulo-emilio': 'CINUSP', 
     'cmu-eca': 'CMU ECA', 'comix-book-shop': 'Comix Book Shop', 'coseas-coordenadoria-de-assistencia-social': 'COSEAS', 'creche-e-pre-escola-central': 'creche e Pré Escola Central', 'crechepre-escola-oeste': 'Creche e pré-escola Oeste',
     'crnutri-fsp-faculdade-de-saude-publica': 'Faculdade de Saúde Pública', 'cti-coordenadoria-de-tecnologia-da-informacao': 'CTI - Coordenadoria de Tecnlogia da Informação', 'each-escola-de-artes-ciencias-e-humanidades': 'EACH',
     'dti-departamento-de-tecnologia-da-informacao': 'DTI - Departamento de Tecnologia da Informação', 'eca-auditorio-olivier-toni': 'ECA - Auditório Oliver Toni', 'eca-conjunto-arquitetonico-das-artes': 'ECA - Conjunto Arquitetônico das Artes',
     'eca-escola-de-comunicacao-e-artes': 'ECA','eca-teatro-laboratorio-da-eca': 'ECA - Teatro Laboratório' , 'edificio-brasiliana': 'Edifício Brasiliana', 'edusp-editora-da-usp': 'EDUSP', 'ee-escola-de-enfermagem': 'EE - Escola de Enfermagem',
     'eefe-escola-de-educacao-fisica-e-esporte': 'EEFE', 'escola-de-aplicacao': 'Escola de Aplicação', 'escola-de-educacao-permanente-hcfmusp': 'Escola de Educação Permanente', 'espaco-agora-capital': 'Espaço Agora','fm-faculdade-de-medicina': 'Faculdade de Medicina',
     'espaco-cultural-porto-seguro': 'Espaço Cultural Porto Seguro', 'espaco-de-atividades-educativas': 'Espaço de Atividades Educativas', 'estacao-meteorologica-do-iag': 'IAG- Estação Meterológica', 'expo-center-norte-capital': 'Expo Center Norte', 
     'fapcom-faculdade-paulus-de-tecnologia-e-comunicacao': 'FAPCOM', 'fau-faculdade-de-arquitetura-e-urbanismo': 'FAU', 'fau-maranhao-2': 'FAU - Rua Maranhão', 'fcf-faculdade-de-ciencias-farmaceuticas': 'FCF - Faculdade de Ciências Farmacêuticas',
     'fd-faculdade-de-direito': 'Faculdade de Direito', 'fe-faculdade-de-educacao': 'FE - Faculdade de Educação', 'fea-faculdade-de-economia-administracao-e-contabilidade': 'FEA', 'iea-institutos-de-estudos-avancados': 'IEA', 'reitoria': 'Reitoria',
     'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-departamento-de-historia': 'FFLCH', 'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas': 'FFLCH', 'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-departamento-de-ciencia-politica': 'FFLCH', 
     'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-departamento-de-filosofia-e-ciencias-sociais': 'FFLCH', 'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-departamento-de-geografia': 'FFLCH', 'fupam-fundacao-para-a-pesquisa-em-arquitetura-e-ambiente': 'FUPAM',
     'fflch-faculdade-de-filosofia-de-letras-e-ciencias-humanas-departamento-de-letras': 'FFLCH', 'fflch-faculdade-de-filosofia-letras-e-ciencias-humanas-cedhal': 'FFLCH', 'fmvz-faculdade-de-medicina-veterinaria-e-zootecnia': 'FMVZ - Faculdade de Medicina Veterinária e Zootecnia', 
     'fo-faculdade-de-odontologia': 'Faculdade de Odontologia', 'fsp-faculdade-de-saude-publica': 'Faculdade de Saúde Pública', 'galpao-ponto-de-cultura-escola-da-rua': 'Galpão: Ponto de Cultura Escola da Rua',  'icb-instituto-de-ciencias-biomedicas': 'ICB',
     'hospital-das-clinicas': 'Hospital das Clínicas', 'hospital-das-clinicas-instituto-da-crianca': 'Hospital das Clínicas', 'hospital-universitario-hu': 'Hospital Uniersitário', 'iag-instituto-de-astronomia-geofisica-e-ciencias-atmosfericas': 'IAG',
     'icb-i-instituto-de-ciencias-biomedicas': 'ICB-I', 'icb-ii-instituto-de-ciencias-biomedicas': 'ICB-II', 'icb-iv-instituto-de-ciencias-biomedicas': 'ICB: IV',  'ieb-instituto-de-estudos-brasileiros': 'IEB', 'iee-instituto-de-eletrotecnica-e-energia': 'IEE', 
     'if-instituto-de-fisica': 'IF - Instituto de Física', 'igc-instituto-de-geociencias': 'IGC', 'ime-instituto-de-matematica-e-estatistica': 'IME USP', 'ib-instituto-de-biociencias': 'IB - Instituto de Biociências', 'instituto-do-coracao-incor': 'INCOR',
     'imt-instituto-de-medicina-tropical-de-sao-paulo': 'IMT - Instituto de Medicina Tropical de São Paulo', 'inrad-instituto-de-radiologia-do-hc': 'INRAD: Instituto de Radiologia do HC', 'instituto-central-do-hospital-das-clinicas': 'Instituto Centro do Hospital das Clínicas',  
     'io-instituto-oceanografico': 'Instituto Oceanográfico','ip-instituto-de-psicologia': 'Instituto de Psicologia', 'ipen-2': 'IPEN 2', 'ipq': 'IPQ', 'iq-instituto-de-quimica': 'IQ - Insistuto de Química', 'iri-instituto-de-relacoes-internacionais': 'IRI USP', 
     'laboratorio-de-sustentabilidade-lassu': 'LASSU', 'livraria-joao-alexandre-barbosa': 'Livraria João Alexandre Barbosa', 'mac-museu-de-arte-contemporanea': 'Museu de Arte Conteporânea', 'mae-museu-de-arqueologia-e-etnologia': 'MAE - Museu de Arqueologia e Etnologia', 
     'mp-museu-paulista': 'Museu Paulista', 'nucleo-de-estudos-da-violencia-nev': 'Núcleo de Estudos da Violência', 'nucel-nucleo-de-terapia-celular-e-molecular': 'Nucel', 'nucleo-de-extensao-e-cultura-em-artes-afro-brasileiras': 'Núcleo de Extensão e Cultura em Artes Afro-Brasileiras',
     'nucleo-dos-direitos-da-usp': 'Núcleo de Direitos da USP', 'nupps-nucleo-de-pesquisa-em-politicas-publicas': 'Núcleo de Pesquisa em Políticas Públicas', 'paco-das-artes': 'Paço das Artes', 'poli-escola-politecnica': 'Escola Politécnica',
     'poli-departamento-de-engenharia-de-producao': 'Escola Politécnica', 'poli-departamento-de-engenharia-de-materiais': 'Departamento de Engenharia de Materiais', 'poli-departamento-de-engenharia-naval': 'Departamento de Engenharia Naval', 
     'cocesp-coordenadoria-do-campus-da-capital': 'COCESP', 'prg-pro-reitoria-de-graduacao': 'Pró Reitoria de Graduação', 'praca-das-artes': 'Praça das Artes', 'poli-administracao': 'Escola Politécnica', 'sibi-sistema-integrado-de-bibliotecas': 'SIBI USP', 
     'poli-laboratorio-de-sustentabilidade-lassu': 'Laboratório de Sustentabilidade Poli Lassu', 'praca-do-relogio-capital': 'Praça do Relógio', 'prceu-pro-reitoria-de-cultura-e-extensao-universitaria': 'PRCEU', 
     'prp-pro-reitoria-de-pesquisa': 'PRP - Pró Reitoria de Pesquisa', 'prpg-pro-reitoria-de-pos-graduacao': 'PRPG',
     'sti-superintendencia-de-tecnologia-da-informacao': 'STI', 'tusp-teatro-da-usp': 'TUSP: Teatro da USP'}.each do | key, value | 

      url = 'http://www.eventos.usp.br/?campi-unidades='+key.to_s+'&feed=rss'
      admin = User.find_by email: 'caiodaquinta@gmail.com'
      next_events = Event.next_events
      open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          if (item.pubDate >= Date.today.at_beginning_of_month) && (next_events.where(name: item.title).empty?)
            puts "Title: #{item.title}"
            Event.create name: item.title, planner: admin, description: item.description, location: value, begin_date: item.pubDate
          end
        end
      end
    end
  end
end
