# Đồ án tốt nghiệp

Repository chung cho backend và frontend, làm việc theo quy trình Git với `main`, `develop` và các nhánh công việc.

| Vị trí | Mục đích |
| --- | --- |
| `backend/` | Đặt mã nguồn Spring Boot/Maven: `pom.xml`, `src/` và Maven Wrapper nếu có |
| `frontend/` | Đặt mã nguồn FE dùng npm: `package.json`, `package-lock.json`, `src/` |
| `.github/` | CI, mẫu PR/issue và cấu hình bảo vệ nhánh để import |
| `docs/` | Hướng dẫn quản trị repository |

## Quy trình Git

`feature/*`, `fix/*`, `chore/*` → pull request vào `develop` → kiểm tra → pull request phát hành vào `main`.

- `main`: bản ổn định để demo/bàn giao.
- `develop`: tích hợp thay đổi FE/BE.
- Mỗi tính năng hoặc lỗi có một nhánh riêng.

Đọc [CONTRIBUTING.md](CONTRIBUTING.md) để xem lệnh PowerShell, cách chia nhánh, đồng bộ, review và merge.

## Trạng thái khởi tạo và CI

Repo được thiết lập từ bản chỉ có README; chưa có ứng dụng FE/BE. Các thư mục module hiện chứa hướng dẫn để đưa mã nguồn vào.

CI kiểm tra hướng PR và cấu trúc dự án. Khi có `backend/pom.xml`, CI tự chạy Maven `verify`; khi có `frontend/package.json` cùng `package-lock.json`, CI tự chạy `npm ci` và `npm run build`. Khi chưa có module, job build tương ứng được đánh dấu **skipped**, không được tính là build đã thành công.

Backend mặc định dùng Java 17 trong workflow; chỉnh phiên bản này cho khớp dự án khi đưa code vào. Frontend dùng Node.js 24 qua `frontend/.nvmrc`. CI chưa có bước deploy.

## Bật bảo vệ nhánh

Chủ repo làm theo [docs/GITHUB_SETUP.md](docs/GITHUB_SETUP.md) để import Ruleset cho `main` và `develop`. Việc commit JSON không tự bật Ruleset trên GitHub.
