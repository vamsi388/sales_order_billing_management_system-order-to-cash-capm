namespace sobms.db;

using {
    cuid,
    managed
} from '@sap/cds/common';

entity Customers : cuid, managed {
    name        : String(100) not null;
    email       : String(120);
    creditLimit : Decimal(15, 2) default 50000;
    status      : String(20) enum {
        Active = 'ACTIVE';
        OnHold = 'ON_HOLD';
    } default 'ACTIVE';
    salesOrders : Association to many SalesOrders on salesOrders.customer = $self;
}

entity Products : cuid, managed {
    code      : String(20) not null;
    name      : String(100) not null;
    unitPrice : Decimal(15, 2) not null;
    taxRate   : Decimal(5, 2) default 18.00;
}

entity SalesOrders : cuid, managed {
    customer    : Association to one Customers not null;
    status      : String(20) enum {
        Draft = 'DRAFT';
        Confirmed = 'CONFIRMED';
        Rejected = 'REJECTED';
        Delivered = 'DELIVERED';
        Closed = 'CLOSED';
    } default 'DRAFT';
    totalAmount : Decimal(15, 2) default 0;
    items       : Composition of many SalesOrderItems
                      on items.parent = $self;
    deliveries  : Association to many Deliveries
                      on deliveries.salesOrder = $self;
}

entity SalesOrderItems : cuid {
    parent       : Association to SalesOrders;
    product      : Association to one Products;
    quantity     : Integer not null;
    unitPrice    : Decimal(15, 2) not null;
    deliveredQty : Integer default 0;
    lineAmount   : Decimal(15, 2);
}

entity Deliveries : cuid, managed {
    salesOrder : Association to one SalesOrders not null;
    status     : String(20) enum {
        Pending = 'PENDING';
        Shipped = 'SHIPPED';
        Complete = 'COMPLETE';
    } default 'PENDING';
    items      : Composition of many DeliveryItems
                     on items.parent = $self;
}

entity DeliveryItems : cuid {
    parent     : Association to Deliveries;
    soItem     : Association to one SalesOrderItems;
    shippedQty : Integer not null;
}

entity Invoices : cuid, managed {
    salesOrder  : Association to one SalesOrders not null;
    customer    : Association to one Customers not null;
    invoiceDate : Date;
    dueDate     : Date;
    amount      : Decimal(15, 2);
    taxAmount   : Decimal(15, 2);
    totalAmount : Decimal(15, 2);
    status      : String(20) enum {
        Open = 'OPEN';
        Paid = 'PAID';
        Overdue = 'OVERDUE';
    } default 'OPEN';
}
