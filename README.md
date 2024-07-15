## O Desafio - CustomerSuccess Balancing

Este desafio consiste em um sistema de balanceamento entre clientes e Customer Success (CSs). Os CSs são os Gerentes de Sucesso, são responsáveis pelo acompanhamento estratégico dos clientes.

Dependendo do tamanho do cliente - aqui nos referimos ao tamanho da empresa - nós temos que colocar CSs mais experientes para atendê-los.

Um CS pode atender mais de um cliente, além disso os CSs também podem sair de férias, tirar folga, ou mesmo ficarem doentes, então é preciso levar esses critérios em conta na hora de rodar a distribuição.

Dado este cenário, o sistema distribui os clientes com os CSs de capacidade de atendimento mais próxima (maior) ao tamanho do cliente.

## Getting Started

### Pré-requisitos
- [ruby > 3.0.0](https://www.ruby-lang.org/pt/documentation/installation)
- [bundler](https://www.campuscode.com.br/conteudos/instalando-dependencias-em-aplicacoes-ruby-com-bundler)

### Instalação
- Acessando o projeto

  ```sh
  cd challenge
  ```

  ou
  
  ```sh
  cd challenge-main
  ```

- Instalando o `bundler`

  ```sh
  gem install bundler
  ```

- Instalando as gems do projeto

  ```sh
  bundle install
  ```

### Executando os testes
- No terminal, execute o comando:

  ```sh
  ruby tests/customer_success_balancing_test.rb
  ```