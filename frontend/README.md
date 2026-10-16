# Frontend

Đặt mã nguồn FE tại đây, với `package.json` và `package-lock.json` trực tiếp trong `frontend/`. CI dùng npm và Node.js 24 theo `.nvmrc`.

Khi đã có project, chạy trong PowerShell:

```powershell
cd frontend
npm ci
npm run build
```

Để chạy môi trường phát triển, dùng script tương ứng trong `package.json`, ví dụ `npm run dev` nếu project dùng Vite.

Commit cả `package.json` và `package-lock.json` khi đổi dependency. CI yêu cầu script `build`; chưa tự chạy test/lint FE vì chưa có cấu hình ứng dụng. Bổ sung các bước đó trong workflow khi chọn công cụ kiểm thử.

Giữ cấu hình riêng ở `.env.local` và commit `.env.example` với giá trị giả. Các biến được nhúng vào bundle frontend có thể được người dùng xem, nên không đặt khóa bí mật trong đó.
