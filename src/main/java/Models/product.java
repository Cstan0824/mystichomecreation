package Models;

import java.sql.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "Product")
public class product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_type_id", referencedColumnName = "product_type_id")
    private productType type;

    @Column(name = "product_title", length = 50, nullable = false)
    private String title;

    @Column(name = "product_slug", length = 50)
    private String slug;

    @Column(name = "product_desc", length = 255)
    private String description;

    @Column(name = "product_price")
    private double price;

    @Column(name = "product_stock")
    private int stock;

    @Column(name = "product_retail_info", length = 255)
    private String retailInfo;

    @Column(name = "product_featured")
    private int featured;

    @Column(name = "product_variations", columnDefinition = "json")
    private String variations; // Store raw JSON as string

    @Column(name = "product_created_date")
    private Date createdDate;

    @Column(name = "product_image_url", length = 255)
    private String imageUrl;

    // Default constructor
    public product() {}

    // Parameterized constructor
    public product(productType type, String title, String slug, String description, double price, int stock,
                   String retailInfo, int featured, String variations, Date createdDate, String imageUrl) {
        this.type = type;
        this.title = title;
        this.slug = slug;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.retailInfo = retailInfo;
        this.featured = featured;
        this.variations = variations;
        this.createdDate = createdDate;
        this.imageUrl = imageUrl;
    }

    // === Getters & Setters ===
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public productType getTypeId() {
        return type;
    }

    public void setTypeId(productType type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getRetailInfo() {
        return retailInfo;
    }

    public void setRetailInfo(String retailInfo) {
        this.retailInfo = retailInfo;
    }

    public int getFeatured() {
        return featured;
    }

    public void setFeatured(int featured) {
        this.featured = featured;
    }

    public String getVariations() {
        return variations;
    }

    public void setVariations(String variations) {
        this.variations = variations;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
