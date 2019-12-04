# Rales Engine

Rales Engine is an web-based API built in Ruby on Rails to expose fabricated sales data. It exposes data through three types of endpoints: record, relationship, and business intelligence endpoints.

## Setup Instructions

To run this API on your device, navigate to your desired directory and execute the following commands:

```
git clone git@github.com:johnktravers/rales_engine.git
cd rales_engine
bundle install
rake db:{create,migrate}
rake import:all
rails server
```

Be aware that the import task can take some time. Once the commands have finished executing, open a web browser and navigate to `http://localhost:3000`. You can now access any of the endpoints discussed below.

## Database Schema

There are six types of resources (`merchants`, `invoices`, `invoice_items`, `items`, `transactions`, and `customers`). They interact with each other based on the following schema.

![Database Schema](https://github.com/johnktravers/rales_engine/blob/media/rales_engine_schema.png?raw=true)

## Endpoints

### Record Endpoints

Each of the six types of resources (`merchants`, `invoices`, `invoice_items`, `items`, `transactions`, and `customers`) have five record endpoints used to expose data related to that resource:

1. `GET /api/v1/<resource>` returns an index of all records from that resource's table.

2. `GET /api/v1/<resource>/:id` returns a specific record from that resource's table that corresponds to the given ID.

3. `GET /api/v1/find?parameters` returns the first record that matches the specified parameter(s). See below for the parameters available for each resource.

4. `GET /api/v1/find_all?parameters` returns all records that match the specified parameter(s). See below for the parameters available for each resource.

5. `GET /api/v1/random` returns a random record from that resource's table.

##### Available Parameters

The find and find_all endpoints allow the user to search for any of the following parameters for each resource. They are added to the URI like query parameters, in the format `?param1=value1&param2=value2`.

| Merchants    | Invoices      | Invoice Items | Items         | Transactions         | Customers    |
|--------------|---------------|---------------|---------------|----------------------|--------------|
| `id`         | `id`          | `id`          | `id`          | `id`                 | `id`         |
| `name`       | `status`      | `quantity`    | `name`        | `result`             | `first_name` |
| `created_at` | `merchant_id` | `unit_price`  | `description` | `credit_card_number` | `last_name`  |
| `updated_at` | `customer_id` | `invoice_id`  | `unit_price`  | `invoice_id`         | `created_at` |
|              | `created_at`  | `item_id`     | `merchant_id` | `created_at`         | `updated_at` |
|              | `updated_at`  | `created_at`  | `created_at`  | `updated_at`         |              |
|              |               | `updated_at`  | `updated_at`  |                      |              |


##### Note:

- Invoice `status` has a value of either `shipped` or `pending`.
- Transaction `result` has a value of either `success` or `failed`.
- Every resource's `created_at` and `updated_at` parameters follow the format `YYYY-MM-DD HH:MM:SS XXX` where `XXX` is the three-letter time zone abbreviation.

### Relationship Endpoints

Each resource is connected to one or more others by one-to-many relationships. These endpoints allow you to expose data from the resources associated with a specific record of a certain resource.

##### Merchants
```
GET /api/v1/merchants/:id/items
GET /api/v1/merchants/:id/invoices
```

##### Invoices
```
GET /api/v1/invoices/:id/transactions
GET /api/v1/invoices/:id/invoice_items
GET /api/v1/invoices/:id/items
GET /api/v1/invoices/:id/customer
GET /api/v1/invoices/:id/merchant
```

##### Invoice Items
```
GET /api/v1/invoice_items/:id/invoice
GET /api/v1/invoice_items/:id/item
```

##### Items
```
GET /api/v1/items/:id/invoice_items
GET /api/v1/items/:id/merchant
```

##### Transactions
```
GET /api/v1/transactions/:id/invoice
```

##### Customers
```
GET /api/v1/customers/:id/invoices
GET /api/v1/customers/:id/transactions
```

### Business Intelligence Endpoints

These endpoints use complex ActiveRecord and SQL queries to expose data that could be useful for tracking sales performance.

##### All Merchants

- `GET /api/v1/merchants/most_revenue?quantity=x` returns the top `x` merchants ranked by total revenue.

- `GET /api/v1/merchants/most_items?quantity=x` returns the top `x` merchants ranked by total quantity of items sold.

- `GET /api/v1/merchants/revenue?date=x` returns the total revenue for date `x` across all merchants. The date must have the format `YYYY-MM-DD`.

##### Single Merchant

- `GET /api/v1/merchants/:id/customers_with_pending_invoices` returns a collection of customers who have pending (unpaid) invoices. A pending invoice has no transactions with a result of `success`.

- `GET /api/v1/merchants/:id/favorite_customer` returns the customer who has conducted the most total number of successful transactions.

- `GET /api/v1/merchants/:id/revenue` returns the total revenue generated by the given merchant across all transactions.

- `GET /api/v1/merchants/:id/revenue?date=x` returns the total revenue generated by the given merchant on the given date. The date must have the format `YYYY-MM-DD`.

##### All Items

- `GET /api/v1/items/most_revenue?quantity=x` returns the top `x` items ranked by total revenue generated.

- `GET /api/v1/items/most_items?quantity=x` returns the top `x` items ranked by total quantity sold.

##### Single Item

- `GET /api/v1/items/:id/best_day` returns the date with the most sales for the given item using the invoice date. If there are multiple days with an equal number of sales, the most recent day is returned.

##### Single Customer

- `GET /api/v1/customers/:id/favorite_merchant` returns the merchant with whom the customer has conducted the most successful transactions.
