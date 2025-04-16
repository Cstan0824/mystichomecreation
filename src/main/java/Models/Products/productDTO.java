package Models.Products;

public class productDTO {
    public int id;
    public String title;
    public double price;
    public int stock;
    public String retailInfo;
    public String imageUrl;
    public String type;

    public productDTO(product p) {
        this.id = p.getId();
        this.title = p.getTitle();
        this.price = p.getPrice();
        this.stock = p.getStock();
        this.retailInfo = p.getRetailInfo();
        this.imageUrl = p.getImageUrl();
        this.type = p.getTypeId().gettype(); // returns category name
    }
}
