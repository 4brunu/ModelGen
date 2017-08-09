# ModelGen

ModelGen is a command-line tool for generating Swift models from JSON Schemas. Unlike most of the model generators, it works with two files, the `.json` and `.stencil` so you have full control on how you want your models to look like, also if you want to refactor all your models it is simple as changing the template and regenerate them. It will save you time writing boilerplate and eliminate model errors as your application scales in complexity.

#### Schema-defined

The Models are defined in JSON, based on JSON-Schema but not limited to, basically anything you add on schema you can use the template. It is an extensible and language-independent specification.

## Installation

For now you can build from source:
```sh
$ rake cli:install
```

## Getting Started

Take a look at [Example](/Example) folder.

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

import Unbox

{% if spec.description %}
/// {{ spec.description }}
{% endif %}
public struct {{ spec.title }}: Equatable {

    // MARK: Instance Variables

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

    public init(unboxer: Unboxer) throws {
{% for property in spec.properties %}
{% if property.format == "date" %}
        self.{{ property.name }} = {% if property.required %}try{% endif %} unboxer.unbox(key: "{{ property.key }}", formatter: Date.serverDateFormatter())
{% else %}
        self.{{ property.name }} = {% if property.required %}try{% endif %} unboxer.unbox(key: "{{ property.key }}")
{% endif %}
{% endfor %}
    }

    // MARK: - Builder

    public struct Builder {
{% for property in spec.properties %}
        public var {{ property.name }}: {{ property.type }}{% if not property.required %}?{% endif %}
{% endfor %}

        public init(copy: {{spec.title}}) {
{% for property in spec.properties %}
            {{property.name}} = copy.{{property.name}}
{% endfor %}
        }

{% map spec.properties into initializerList using property %}{{ property.name }}: {{ property.name }}{% endmap %}
        public func build() -> {{spec.title}} {
            return {{spec.title}}({{ initializerList|join:", " }})
        }
    }
}

// MARK: - Equatable

public func == (lhs: {{spec.title}}, rhs: {{spec.title}}) -> Bool {
{% for property in spec.properties %}
    guard lhs.{{property.name}} == rhs.{{property.name}} else { return false }
{% endfor %}
    return true
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

Or to generate a single file:
 
```sh
$ modelgen --spec company.json --template template.stencil --output Company.json
```

Generate from a directory:

```sh
$ modelgen -s ./Specs -t template.stencil -o ./Models
```

## Generated Output

```swift
//
//  Company.swift
//  ModelGen
//
//  Generated by [ModelGen]: https://github.com/hebertialmeida/ModelGen
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Unbox

/// Definition of a Company
public struct Company: Equatable {

    // MARK: Instance Variables

    public let subdomain: String
    public let name: String
    public let logo: URL?
    public let id: Int

    // MARK: - Initializers

    public init(subdomain: String, name: String, logo: URL?, id: Int) {
        self.subdomain = subdomain
        self.name = name
        self.logo = logo
        self.id = id
    }

    public init(unboxer: Unboxer) throws {
        self.subdomain = try unboxer.unbox(key: "subdomain")
        self.name = try unboxer.unbox(key: "name")
        self.logo =  unboxer.unbox(key: "logo")
        self.id = try unboxer.unbox(key: "id")
    }

    // MARK: - Builder

    public struct Builder {
        public var subdomain: String
        public var name: String
        public var logo: URL?
        public var id: Int

        public init(copy: Company) {
            subdomain = copy.subdomain
            name = copy.name
            logo = copy.logo
            id = copy.id
        }

        public func build() -> Company {
            return Company(subdomain: subdomain, name: name, logo: logo, id: id)
        }
    }
}

// MARK: - Equatable

public func == (lhs: Company, rhs: Company) -> Bool {
    guard lhs.subdomain == rhs.subdomain else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.logo == rhs.logo else { return false }
    guard lhs.id == rhs.id else { return false }
    return true
}
```

## Contributing

Pull requests for bug fixes and features welcomed.
