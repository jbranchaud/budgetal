Budgetal
--------

About
-----

Budgetal is about helping you save money, planning for expenses, chasing away emergencies, and begin building wealth.

Setup
-----

### Environment Variables

Budgetal is designed to be a [12-Factor](http://12factor.net/) application. As such it uses environment variables for each type of deployment. Budgetal uses the [dotenv-rails gem](https://github.com/bkeepers/dotenv) for each environment. When setting up a new development deploy on your local machine, be sure to `cp .env{.example,}` so you can setup your local configuration.

### Dependencies

Budgetal tests depend on the selenium chrome driver: `brew install chromedriver`

See the [Chrome Driver website](https://sites.google.com/a/chromium.org/chromedriver/) for more details.

### Testing

1. Setup database `RAILS_ENV=test rake db:schema:load`
2. Run tests `rake`

## Credits

[![Budgetal](https://s3.amazonaws.com/cdn.budgetal.com/b.png)](https://www.budgetal.com)

Budgetal is maintained by [Dillon Hafer](http://www.dillonhafer.com)

## License

Budgetal is Copyright © 2013-2015 Dillon Hafer. It is free software, and may be redistributed under the terms specified below.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.