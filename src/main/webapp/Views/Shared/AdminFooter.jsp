<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
</div> <!-- Close the flex container from header -->

<script>
  // Common JavaScript functionality can be placed here
  function confirmDelete(message, url) {
    if (confirm(message)) {
      window.location.href = url;
    }
  }
</script>
</body>
</html>