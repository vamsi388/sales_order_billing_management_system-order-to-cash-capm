using { sobms.db as db } from '../db/schema';
service MyService {
    entity Customers as projection on db.Customers;
    entity Products as projection on db.Products;
    entity SalesOrders as projection on db.SalesOrders
    actions{
        action confirm() returns SalesOrders;
        action reject(reason:String) returns SalesOrders;
    };
    entity SalesOrderItems as projection on db.SalesOrderItems;
    entity Deliveries as projection on db.Deliveries;
    entity DeliveryItems as projection on db.DeliveryItems;
    entity Invoices as projection on db.Invoices actions {
        action markPaid() returns Invoices;
        };
    function getCreditExposure(customerID:UUID) returns Decimal;
    function overdueInvoices() returns array of Invoices;
   
}
