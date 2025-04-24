package Models.Products;

import jakarta.persistence.*;
import java.sql.Blob;

@Entity
@Table(name="Product_Image")
public class productImage {
    
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "image_id")
        private int id;
    
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        @Lob
        @Column(name="image_data", nullable=false, columnDefinition="LONGBLOB")
        private Blob data;
    
        public Blob getData() {
            return data;
        }

        public void setData(Blob data) {
            this.data = data;
        }

        // === Constructors ===
        public productImage() {
            
        }

        // @Lob @Column(name="thumb_data", columnDefinition="LONGBLOB")
        // private Blob thumbnail;

        // public Blob getThumbnail() {
        //     return thumbnail;
        // }

        // public void setThumbnail(Blob thumbnail) {
        //     this.thumbnail = thumbnail;
        // }
    
        
    
}
