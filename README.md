# Brasileirão App - CDUI

![Swift Version](https://img.shields.io/badge/Swift-5.5%2B-orange)
![Platform](https://img.shields.io/badge/Platform-iOS%2013%2B-lightgrey)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-blue)

Este repositório contém a implementação de um aplicativo para acompanhamento de jogos de futebol, consistindo em uma API backend e um aplicativo cliente para iOS. A solução foi desenvolvida com foco em arquitetura moderna, escalabilidade e qualidade de código.

### Arquitetura Geral

O projeto foi estruturado como um "monorepo" contendo dois subprojetos principais:

* **`./api`**: Uma API RESTful desenvolvida com **Java e Spring Boot**.
* **`./ios-app`**: Um aplicativo nativo para iOS desenvolvido com **Swift, SwiftUI e SwiftData**.

A decisão de arquitetura mais impactante foi a implementação de um modelo de **UI Guiada pelo Servidor (Server-Driven UI)**, onde a API define a estrutura de agrupamento dos jogos (ex: por status ou por rodada), e o cliente iOS apenas renderiza a estrutura recebida.
