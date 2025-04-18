<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Products.productVariationOptions" %>
<%@ page import="Models.Products.product" %>
<%@ page import="Models.Products.productType" %>
<%@ page import="Models.Products.productDTO" %>

    <div id="editProductModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[600] overflow-y-auto hidden">
        <div class="bg-white rounded-lg shadow-lg w-full max-w-3xl max-h-[90vh] overflow-y-auto p-6 relative">
    
        <!-- Close Button -->
        <button onclick="closeeditModal()" class="absolute top-2 right-2 text-gray-500 hover:text-red-500 text-2xl">
            <i class="fa-solid fa-xmark"></i>
        </button>

        <!-- Modal Header -->
        <h2 class="text-2xl font-bold mb-6">Update Product</h2>

        <!-- Form -->
        <form id="editProductForm" method="post" action="<%= request.getContextPath() %>/product/updateProduct" class="space-y-4">

            <input type="hidden" name="productId" value="<%= product.getId() %>">

            <!-- Product Name -->
            <div>
                <label class="block mb-1 font-semibold">Product Name</label>
                <input type="text" name="title" id="titleInput" value="<%=product.getTitle()%>" required class="w-full border px-3 py-2 rounded" />
            </div>

            <!-- Description -->
            <div>
                <label class="block mb-1 font-semibold">Description</label>
                <textarea name="description" id="descInput" rows="3" class="w-full border px-3 py-2 rounded"><%= product.getDescription() %></textarea>
            </div>

            <!-- Slug -->
            <div>
                <label class="block mb-1 font-semibold">Product Slug</label>
                <input type="text" name="slug" value="<%=product.getSlug()%>" id="slugInput" readonly class="w-full border px-3 py-2 rounded" />
            </div>

            <!-- Price & Stock -->
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 font-semibold">Price (RM)</label>
                    <input type="number" name="price" value="<%=product.getPrice()%>" step="0.01" required class="w-full border px-3 py-2 rounded" />
                </div>

                <div>
                    <label class="block mb-1 font-semibold">Stock</label>
                    <input type="number" value="<%=product.getStock()%>" name="stock" required class="w-full border px-3 py-2 rounded" />
                </div>
            </div>

            <!-- Product Variations -->
            <div>
                <label class="block mb-1 font-semibold">Product Variations</label>
                <div id="variationContainer" class="space-y-4">
                    <%

                        if (options != null && options.getOptions() != null) {
                           for (Map.Entry<String, List<String>> entry : options.getOptions().entrySet()) {
                                
                    %>
                    <div class="variation-block bg-gray-50 p-4 mb-4 rounded border">
                        <div class="flex gap-4 mb-2">
                            <div class="flex-1">
                                <label class="block mb-1 font-semibold">Variation Title</label>
                                <input type="text" name="variation-title" class="w-full border px-3 py-2 rounded" value="<%= entry.getKey() %>" />
                            </div>

                            <div class="flex-1">
                                <label class="block mb-1 font-semibold">Options</label>
                                <div class="option-list space-y-2 mb-2">
                                    <% for (String value : entry.getValue()) { %>                                    
                                    <div class="flex items-center gap-2">
                                        <input type="text" name="variation-option" class="flex-1 border px-3 py-2 rounded" value="<%= value %>" />
                                        <button type="button" class="text-red-500" onclick="removeOptionField(this)">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </div>
                                    <% } %>
                                </div>
                                <button type="button" class="bg-blue-500 text-white px-3 py-1 rounded" onclick="addOptionField(this)">Add Option</button>
                            </div>

                            <button type="button" onclick="removeVariation(this)" class="text-red-500 hover:text-red-700">
                                <i class="fa-solid fa-circle-minus"></i>
                            </button>
                        </div>
                    </div>
                    <%
                            } 
                        }   
                    %>
                    <textarea id="variationsJson" name="variations" hidden></textarea>

                    <button type="button" onclick="addVariation()" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Variation</button>
                </div>
            </div>

            <!-- Category -->
            <div>
                <label class="block mb-1 font-semibold">Category</label>
                <select name="typeId" required class="w-full border px-3 py-2 rounded">
                    <option value="">Select</option>
                    <%
                    List<productType> types = (List<productType>) request.getAttribute("productTypes");
                    if (types != null) {
                        for (productType t : types) {
                            if (t.getId() == product.getTypeId().getId()) {
                    %>
                    <option value="<%=t.getId()%>" selected><%=t.gettype()%></option>
                    <%
                            }
                        }
                        for (productType t : types) {
                            if (t.getId() != product.getTypeId().getId()) {
                    %>
                    <option value="<%=t.getId()%>"><%=t.gettype()%></option>
                    <%
                            }
                        }
                    }
                    %>
                </select>
            </div>

            <!-- Retail Info -->
            <div>
                <label class="block mb-1 font-semibold">Retail Info</label>
                <input type="text" name="retailInfo" value="<%=product.getRetailInfo()%>" class="w-full border px-3 py-2 rounded" />
            </div>

            <!-- Image URL -->
            <div>
                <label class="block mb-1 font-semibold">Image URL</label>
                <input type="text" name="imageUrl" class="w-full border px-3 py-2 rounded" />
            </div>

            <!-- Featured -->
            <div>
                <label class="inline-flex items-center">
                    <input type="checkbox" name="featured" class="form-checkbox" <%= product.getFeatured() == 1 ? "checked" : "" %>/>
                    <span class="ml-2">Mark as Featured</span>
                </label>
            </div>

            <!-- Submit Button -->
            <div class="text-right">
                <button type="submit" class="bg-yellow-500 hover:bg-yellow-600 text-white px-5 py-2 rounded">Update Product</button>
            </div>
        </form>
    </div>
</div>

<script>
    function addVariation() {
        const container = document.getElementById("variationContainer");
        const block = document.createElement("div");
        block.className = "variation-block bg-gray-50 p-4 mb-4 rounded border";
        block.innerHTML = `
            <div class="flex gap-4 mb-2">
                <div class="flex-1">
                    <label class="block mb-1 font-semibold">Variation Title</label>
                    <input type="text" name="variation-title" placeholder="Title e.g. Size" class="w-full border px-3 py-2 rounded" />
                </div>
                <div class="flex-1">
                    <label class="block mb-1 font-semibold">Options</label>
                    <div class="option-list space-y-2 mb-2"></div>
                    <button type="button" class="bg-blue-500 text-white px-3 py-1 rounded" onclick="addOptionField(this)">Add Option</button>
                </div>
                <button type="button" onclick="removeVariation(this)" class="text-red-500 hover:text-red-700">
                    <i class="fa-solid fa-circle-minus"></i>
                </button>
            </div>
        `;
        container.appendChild(block);
    }

    document.getElementById('editProductForm').addEventListener('submit', function() {
        const blocks = document.querySelectorAll('.variation-block');
        const variationObj = {};
        blocks.forEach(block => {
            const titleInput = block.querySelector('input[name="variation-title"]');
            const title = titleInput.value.trim();
            if (!title) return;
            const optInputs = block.querySelectorAll('input[name="variation-option"]');
            const opts = Array.from(optInputs).map(i => i.value.trim()).filter(v => v.length);
            if (opts.length) variationObj[title] = opts;
        });
        const hiddenField = document.getElementById('variationsJson');
        hiddenField.value = Object.keys(variationObj).length ? JSON.stringify(variationObj) : '';
    });

    function addOptionField(btn) {
        const list = btn.closest('.variation-block').querySelector('.option-list');
        const optDiv = document.createElement('div');
        optDiv.className = 'flex items-center gap-2';
        optDiv.innerHTML = `
            <input type="text" name="variation-option" class="flex-1 border px-3 py-2 rounded" placeholder="Option value" required />
            <button type="button" class="text-red-500" onclick="removeOptionField(this)">
                <i class="fa-solid fa-trash"></i>
            </button>
        `;
        list.appendChild(optDiv);
    }

    function removeVariation(btn) {
        btn.closest(".variation-block").remove();
    }

    function removeOptionField(btn) {
        btn.parentElement.remove();
    }

    document.querySelector('input[name="title"]').addEventListener('input', function(e) {
        const slugField = document.querySelector('input[name="slug"]');
        const title = e.target.value;
        const slug = title.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '');
        slugField.value = slug;
    });
</script>
