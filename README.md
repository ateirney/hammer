# hammer 

hammer is a command-line tool to schema management for Google Cloud Spanner.

![](https://github.com/daichirata/hammer/workflows/Test/badge.svg)

## Installation

Download the single-binary executable from:

https://github.com/daichirata/hammer/releases

or

``` shell
$ go get -u github.com/daichirata/hammer
```

## Usage

```
$ hammer -h
hammer is a command-line tool to schema management for Google Cloud Spanner.

Usage:
  hammer [command]

Examples:

* Export spanner schema
  hammer export spanner://projects/projectId/instances/instanceId/databases/databaseName > schema.sql

* Apply local schema file
  hammer apply spanner://projects/projectId/instances/instanceId/databases/databaseName /path/to/file

* Create database and apply local schema (faster than running database creation and schema apply separately)
  hammer create spanner://projects/projectId/instances/instanceId/databases/databaseName /path/to/file

* Copy database
  hammer create spanner://projects/projectId/instances/instanceId/databases/databaseName1 spanner://projects/projectId/instances/instanceId/databases/databaseName2

* Compare local files
  hammer diff /path/to/file /another/path/to/file

* Compare local file against spanner schema
  hammer diff /path/to/file spanner://projects/projectId/instances/instanceId/databases/databaseName

* Compare spanner schema against spanner schema
  hammer diff spanner://projects/projectId/instances/instanceId/databases/databaseName1 spanner://projects/projectId/instances/instanceId/databases/databaseName2

Available Commands:
  apply       Apply schema
  create      Create database and apply schema
  diff        Diff schema
  export      Export schema
  help        Help about any command

Flags:
  -h, --help   help for hammer

Use "hammer [command] --help" for more information about a command.
```

The DSN must be given in the following format.

```
spanner://projects/{projectId}/instances/{instanceId}/databases/{databaseName}?credentials=/path/to/file.json
```

| Param          | Required |  Description                                                                                   |
| -------------- | -------- | ---------------------------------------------------------------------------------------------- |
| `projectId`    | true     | The Google Cloud Platform project id                                                           |
| `instanceId`   | true     | The id of the instance running Spanner                                                         |
| `databaseName` | true     | The name of the Spanner database                                                               |
| `credentials`  | false    | The path to the keyfile. If not present, client will use your default application credentials. |

### Examples

Suppose you have an existing SQL schema like the following:

``` sql
CREATE TABLE users (
  user_id STRING(36) NOT NULL,
) PRIMARY KEY(user_id);
```

And you want "upgrade" your schema to the following:

``` sql
CREATE TABLE users (
  user_id STRING(36) NOT NULL,
  age INT64,
  name STRING(MAX) NOT NULL,
) PRIMARY KEY(user_id);
CREATE INDEX idx_users_name ON users (name);
```

Hammer changes the schema by applying the following SQL to the spanner:

``` sql
hammer diff old.sql new.sql

ALTER TABLE users ADD COLUMN age INT64
ALTER TABLE users ADD COLUMN name STRING(MAX)
UPDATE users SET name = '' WHERE name IS NULL
ALTER TABLE users ALTER COLUMN name STRING(MAX) NOT NULL
CREATE INDEX idx_users_name ON users(name)
```

When adding a column with the NOT NULL attribute, update the default value after adding the column once, and then add the NOT NULL attribute.

## LICENSE

Unless otherwise noted, the hammer source files are distributed under the MIT License found in the LICENSE file.
