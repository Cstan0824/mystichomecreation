<!DOCTYPE html>
<html>
<head>
    <title>File Upload Form</title>
</head>
<body>

    <h2>Upload a File</h2>
    <form action="<%= request.getContextPath() %>/dev/getFromAttachFile" method="post" enctype="multipart/form-data">
        <label for="file">Choose a file:</label>
        <input type="file" name="file" id="file" required>
        <br><br>
        <button type="submit">Upload</button>

        <image src="<%= request.getContextPath() %>/File/Content/getImage?id=3" style="cursor: pointer; width: 20px; height: 20px; ">

        <a href="<%= request.getContextPath() %>/File/Content/testDownload?id=1" style="">Download Link</a>
    </form>
    <script>
    let data = {
        userCredential: {
            username: "adminroot",
            password: "sa"
        }
    };

    let jsonData = JSON.stringify(data);
    
    </script>
</body>
</html>