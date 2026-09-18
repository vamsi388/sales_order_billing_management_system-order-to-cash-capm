# SOBMS — Sales Order & Billing Management System

Enterprise Order-to-Cash backend built on SAP CAP (CDS + Node.js): Customer credit-limit
enforcement, Sales Order approval workflow, partial Delivery tracking, and automated
Invoice generation.

## Business Flow

Customer (Active/OnHold, CreditLimit)
   -> Sales Order (Draft -> credit check -> Confirmed/Rejected)
   -> Delivery (Partial/Full, reduces open order qty)
   -> Invoice (auto-generated on full delivery -> Open/Paid/Overdue)

## Features

- Credit-limit exposure check before confirming a Sales Order
- Composition-based Header/Item modeling (SalesOrders -> SalesOrderItems, Deliveries -> DeliveryItems)
- Partial delivery tracking against ordered quantity
- Auto invoice generation with tax calculation on full delivery
- Actions: confirm, reject, markPaid
- Functions: getCreditExposure, overdueInvoices
- Full OData V4 query support ($filter, $expand, $select, $orderby, $top, $skip, $count)

## Structure

sobms/
├── db/schema.cds
├── srv/sales-service.cds
├── srv/sales-service.js
├── package.json

## Run locally

npm install
cds deploy --to sqlite:db.sqlite
cds watch

Service live at: http://localhost:4004/sales/

## Sample calls

GET /sales/SalesOrders?$filter=status eq 'CONFIRMED'&$expand=customer,items
POST /sales/SalesOrders  { customer_ID, items: [{ product_ID, quantity, unitPrice }] }
POST /sales/SalesOrders(<id>)/SalesService.confirm
POST /sales/Deliveries  { salesOrder_ID, items: [{ soItem_ID, shippedQty }] }
GET /sales/overdueInvoices()

## Author

Gundlapalle Vamsi — SAP BTP Developer (CAPM / Node.js / UI5-Fiori)

## License

MIT
