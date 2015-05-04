Copyright 2014 Josh Software Pvt. Ltd.

21nautica
=========

[![Code Climate](https://codeclimate.com/github/joshsoftware/21nautica.png)](https://codeclimate.com/github/joshsoftware/21nautica)
[![Test Coverage](https://codeclimate.com/github/joshsoftware/21nautica/coverage.png)](https://codeclimate.com/github/joshsoftware/21nautica)
[![Circle CI](https://circleci.com/gh/joshsoftware/21nautica.png?circle-token=b35bfb25be8aac57a6ed5362024c74e73d7b8dcc)](https://circleci.com/gh/joshsoftware/21nautica)


**Manage import / export of orders for 21nautica**

**Testing:**
Minitest is used for testing. Run test cases using `rake test`.

**Rake tasks:**

1. Rake to send daily import and export reports(`rake report:import_report`, `rake report:export_report`)

2. Rake to log and send reports for changes made in the past 24 hours to ImportExpense, Transporter Payment and Clearing Agent Payment in Movement, any changes to BL expenses, Payments Made and Payments received (`rake report:expense_delta`)

3. Rake to upload older invoices

  steps:
    - Comment out `assign_parent_invoice_number` callback of invoice.
    - Get database credentials using `$ heroku pg:credentials --app app_name` and copy them to config/database.yml
    - execute `rake invoices:add_older filename='<csv file path>'`
    - checkout both config/database.yml and app/models/invoice.rb

  Follow above steps as we do not want invoices sheet to be commited to repo and also to ensure that no invoice number will not change due to `assign_parent_invoice_number` callback. 
