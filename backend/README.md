# Backend

Đặt project Spring Boot/Maven tại đây để file `pom.xml` nằm trực tiếp trong `backend/`.

Các file cần đưa vào Git gồm `pom.xml`, `src/` và Maven Wrapper (`mvnw`, `mvnw.cmd`, `.mvn/wrapper/`) nếu project có dùng. CI mặc định dùng Java 17; đổi `java-version` trong `.github/workflows/ci.yml` nếu project dùng Java khác.

Khi đã có project, chạy trong PowerShell:

```powershell
cd backend
.\mvnw.cmd --batch-mode --no-transfer-progress verify
.\mvnw.cmd spring-boot:run
```

Nếu không có Maven Wrapper, dùng `mvn` đã cài trên máy. Trên Linux/macOS có wrapper thì dùng `sh mvnw`.

CI chạy `verify`, bao gồm các test được Maven cấu hình. Hãy chuẩn bị profile/môi trường kiểm thử riêng nếu test cần database hoặc dịch vụ khác. Cấu hình hiện tại chưa cấp database hay chạy ứng dụng.

Giữ mật khẩu và khóa trong biến môi trường hoặc `application-local.properties/yml` được ignore; commit file ví dụ với giá trị giả khi cần.
