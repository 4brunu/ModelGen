# ModelGen 🎰

**ModelGen** is a command-line tool for generating models from JSON Schemas. 

[![Build Status](https://travis-ci.org/hebertialmeida/ModelGen.svg?branch=master)](https://travis-ci.org/hebertialmeida/ModelGen) ![GitHub](https://img.shields.io/github/license/hebertialmeida/modelgen.svg?color=%234c1) [![codecov](https://codecov.io/gh/hebertialmeida/ModelGen/branch/master/graph/badge.svg)](https://codecov.io/gh/hebertialmeida/ModelGen)

## Why?

Models are usually boilerplate code, why not generate them and forget? It will save you time writing boilerplate and eliminate model errors as your application scales in complexity.

This means that adding a property to a data object is truly a one-line change — no copy-paste required. If you want to refactor all your models it is simple as changing the template and regenerate them.

## How?

Unlike most of the model generators, it works with two files, the `.json` and [`.stencil`](https://github.com/kylef/Stencil) so you have full control on how you want your models to look like.

The Models are defined in JSON, based on JSON Schema but not limited to, basically anything you add on schema you can use the template. It is an extensible and language-independent specification.

## Examples?

Take a look at [Example](/Example) folder.

## Requirements

- Xcode 10.2+ and Swift 4.2+

## Installation

### Homebrew

Run the following command to install using [homebrew](https://brew.sh/):

```sh
$ brew tap hebertialmeida/ModelGen https://github.com/hebertialmeida/ModelGen.git
$ brew install ModelGen
```

### Manually

Run the following commands to build and install manually:

```terminal
$ git clone https://github.com/hebertialmeida/ModelGen.git
$ cd ModelGen
$ make install
```

## Defining a schema

ModelGen takes a schema file as an input.

```json
{
  "title": "Company",
  "type": "object",
  "description": "Definition of a Company",
  "identifier": "id",
  "properties": {
    "id": {"type": "integer"},
    "name": {"type": "string"},
    "logo": {"type": "string", "format": "uri"},
    "subdomain": {"type": "string"}
  },
  "required": ["id", "name", "subdomain"]
}
```

## Defining a template

ModelGen takes a template to generate in the format you want.

```swift
//
//  {{ spec.title }}.swift
//  ModelGen
//
//  Generated by [ModelGen]: https://github.com/hebertialmeida/ModelGen
//  Copyright © {% now "yyyy" %} ModelGen. All rights reserved.
//

{% if spec.description %}
/// {{ spec.description }}
{% endif %}
public struct {{ spec.title }} {
{% for property in spec.properties %}
{% if property.doc %}
    /**
     {{ property.doc }}
     */
{% endif %}
    public let {{ property.name }}: {{ property.type }}{% if not property.required %}?{% endif %}
{% endfor %}

    // MARK: - Initializers

{% map spec.properties into params using property %}{{ property.name }}: {{ property.type }}{% if not property.required %}?{% endif %}{% endmap %}
    public init({{ params|join:", " }}) {
{% for property in spec.properties %}
        self.{{ property.name }} = {{ property.name }}
{% endfor %}
    }
}

// MARK: - Equatable

extension {{ spec.title }}: Equatable {
    static public func == (lhs: {{spec.title}}, rhs: {{spec.title}}) -> Bool {
{% for property in spec.properties %}
        guard lhs.{{property.name}} == rhs.{{property.name}} else { return false }
{% endfor %}
        return true
    }
}
```

## Generating models

To make it easy you can create a `.modelgen.yml`

```yaml
spec: ../Specs/
output: ./Model/
template: template.stencil
language: swift # Only swift is supported right know
```

And then:
```sh
$ modelgen
```

#### Without the `.modelgen.yml` file

Generate from a directory:

```sh
$ modelgen --spec ./Specs --template template.stencil --output ./Model
```

Generate a single file:
 
```sh
$ modelgen --spec company.json --template template.stencil --output Company.swift
```

## Generated output

```swift
//
//  Company.swift
//  ModelGen
//
//  Generated by [ModelGen]: https://github.com/hebertialmeida/ModelGen
//  Copyright © 2019 ModelGen. All rights reserved.
//

/// Definition of a Company
public struct Company {
    public let id: Int
    public let logo: URL?
    public let name: String
    public let subdomain: String

    // MARK: - Initializers

    public init(id: Int, logo: URL?, name: String, subdomain: String) {
        self.id = id
        self.logo = logo
        self.name = name
        self.subdomain = subdomain
    }
}

// MARK: - Equatable

extension Company: Equatable {
    static public func == (lhs: Company, rhs: Company) -> Bool {
        guard lhs.id == rhs.id else { return false }
        guard lhs.logo == rhs.logo else { return false }
        guard lhs.name == rhs.name else { return false }
        guard lhs.subdomain == rhs.subdomain else { return false }
        return true
    }
}
```

## Attributions

This tool is powered by:

- [Stencil](https://github.com/kylef/Stencil) and few other libs by [Kyle Fuller](https://github.com/kylef)
- [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit) by [SwiftGen](https://github.com/SwiftGen/)

The inital concept was based on [Peter Livesey's](https://github.com/plivesey) [pull request](https://github.com/SwiftGen/SwiftGen/pull/188) and inspired by [plank](https://github.com/pinterest/plank) from Pinterest.

If you want to contribute, don't hesitate to open an pull request.

## License

ModelGen is available under the MIT license. See the [LICENSE](/LICENSE) file.
