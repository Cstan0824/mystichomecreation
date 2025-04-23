package DTO;

import Models.Orders.Order;

public class OrderDTO {
    public int id;
    public String orderRefNo;
    public String username;
    public String status;
    public double totalPaid;
    public String orderDate;
    

    public OrderDTO(Order order) {
        this.id = order.getId();
        this.orderRefNo = order.getOrderRefNo();
        this.username = order.getUser().getUsername();
        this.status = order.getStatus().getStatusDesc();
        this.totalPaid = order.getPayment().getTotalPaid();
        this.orderDate = order.getOrderDate();
    }
}
