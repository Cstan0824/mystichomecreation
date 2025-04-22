package Models.Products;

public class productDTO {
    public int id;
    public String title;
    public double price;
    public int stock;
    public String retailInfo;
    public String type;
    public int productImageId;
    

    public productDTO(product p) {

        this.id = p.getId();
        this.title = p.getTitle();
        this.price = p.getPrice();
        this.stock = p.getStock();
        this.retailInfo = p.getRetailInfo();
        this.type = p.getTypeId().gettype(); // returns category name
        this.productImageId = p.getImage().getId();  
    }
}
