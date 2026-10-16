# Quy trình Git của nhóm

## Các nhánh và hướng pull request

| Nhánh | Tạo từ | PR đến | Mục đích |
| --- | --- | --- | --- |
| `main` | Có sẵn | — | Bản ổn định để demo/bàn giao |
| `develop` | `main` khi khởi tạo | `main` | Tích hợp FE/BE |
| `feature/<issue>-<ten>` | `develop` | `develop` | Tính năng mới |
| `fix/<issue>-<ten>` | `develop` | `develop` | Sửa lỗi đang phát triển |
| `chore/<ten>`, `ci/<ten>` | `develop` | `develop` | Cấu hình, công cụ, CI |
| `docs/<ten>`, `test/<ten>`, `refactor/<ten>` | `develop` | `develop` | Tài liệu, kiểm thử, cải tổ code |
| `release/<phien-ban>` | `develop` | `main` | Tùy chọn: ổn định bản phát hành |
| `hotfix/<ten>` | `main` | `main` | Sửa lỗi khẩn cấp của bản ổn định |

Tên nhánh viết thường, không dấu, phần tên chỉ gồm chữ/số và dấu `-`. Ví dụ: `feature/12-login-ui`, `feature/13-login-api`, `fix/18-validation`, `release/1-0-0`.

FE và BE cùng dùng `develop`; chia nhánh theo công việc. Một công việc cần cả API và giao diện có thể ở chung một nhánh.

## Bắt đầu công việc trên Windows

Clone lần đầu:

```powershell
git clone https://github.com/ducnguyen122003/doantotnghiep.git
cd doantotnghiep
git fetch origin
git switch develop
git pull --ff-only origin develop
git switch -c feature/12-login-ui
```

Nếu đã có repo, bắt đầu từ `git fetch origin`. Chỉ chuyển nhánh khi đã commit hoặc cất các thay đổi đang làm dở.

Sau khi sửa code, kiểm tra và thêm đúng các file của công việc:

```powershell
git status
git add frontend/src
git commit -m "feat(frontend): add login page"
git push -u origin feature/12-login-ui
```

Đường dẫn `frontend/src` là ví dụ; thay bằng file/thư mục bạn đã sửa. Trên GitHub mở PR với **base: `develop`**, **compare: nhánh công việc** và điền mẫu PR.

## Đưa mã nguồn vào repo mới

Repo khởi tạo chưa có mã nguồn ứng dụng. Đưa code vào các vị trí:

- Backend Maven: `backend/pom.xml`, `backend/src/`; thêm Maven Wrapper nếu có.
- Frontend npm: `frontend/package.json`, `frontend/package-lock.json`, `frontend/src/`.

Có thể tạo nhánh `chore/import-source` từ `develop`, đưa source vào, kiểm tra rồi mở PR vào `develop`. Kiểm tra `.gitignore`, giữ cấu hình local và thông tin bí mật trên máy; commit file ví dụ khi cần. `.gitignore` không tự gỡ file đã được Git theo dõi.

## Đồng bộ và giải quyết conflict

Khi đang ở nhánh công việc, working tree sạch:

```powershell
git fetch origin
git merge origin/develop
git push
```

Nếu conflict: sửa các đoạn Git đánh dấu, kiểm tra lại, `git add` từng file đã giải quyết, `git commit`, rồi `git push`. Dùng `git merge --abort` nếu cần hủy lần merge đang xử lý.

## CI và kiểm tra trước khi merge

Các check bắt buộc trong Ruleset được chuẩn bị sẵn là **Branch policy**, **Project layout**, **CI result**.

| Check/job | Hành vi |
| --- | --- |
| Branch policy | Kiểm tra tên và hướng PR |
| Project layout | Nhận diện module; báo lỗi nếu có `src/` nhưng thiếu manifest, hoặc FE có package nhưng thiếu lockfile |
| Backend verify | Khi có `backend/pom.xml`: Java 17, Maven Wrapper nếu có, chạy `verify` |
| Frontend build | Khi có `frontend/package.json`: Node 24, `npm ci`, `npm run build` |
| CI result | Chỉ đạt khi các check bắt buộc và mọi module có mặt đều kiểm tra thành công |

Khi chưa có code, hai job module được **skipped**; đây chưa phải kết quả build/kiểm thử ứng dụng. Khi đã có module, job bị lỗi, bị hủy hoặc bị skip bất thường sẽ làm `CI result` thất bại. CI chạy trên mọi PR vào `main`/`develop` và push lên hai nhánh để required checks không bị treo vì bộ lọc đường dẫn.

Backend mặc định dùng Java 17; chỉnh `java-version` trong workflow cho khớp source. `verify` có chạy test theo cấu hình Maven, nên cần profile/môi trường test nếu test phụ thuộc database/dịch vụ ngoài. FE hiện chưa có bước test/lint; bổ sung khi có công cụ của ứng dụng. Workflow chưa có deploy.

Thực hiện các lệnh kiểm tra trong [backend/README.md](backend/README.md) và [frontend/README.md](frontend/README.md) khi đưa code vào. Người review cần thử chức năng, quyền truy cập và thay đổi dữ liệu liên quan; bổ sung ảnh khi sửa FE.

## Quy tắc merge, phát hành và hotfix

1. Nhánh công việc → `develop`: dùng **Squash and merge** sau khi CI và review đạt.
2. `develop` hoặc `release/*` → `main`: dùng **Create a merge commit**, giữ lịch sử hai nhánh dài hạn.
3. `hotfix/*` tạo từ `main`, mở PR vào `main`, dùng **Create a merge commit**.
4. Sau phát hành/hotfix, mở PR **`main` → `develop`**, dùng **Create a merge commit** để đồng bộ lịch sử và bản sửa lỗi. CI cho phép hướng này.
5. Giữ `main` và `develop`; chỉ xóa nhánh công việc/release/hotfix đã hoàn tất.

Sau khi một nhánh được squash merge, chuyển về `develop` và tạo nhánh mới cho việc tiếp theo. Khi chốt phiên bản, có thể tạo tag trên `main` sau khi PR đã merge:

```powershell
git fetch origin
git switch main
git pull --ff-only origin main
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

## Quy ước commit

`<type>(<scope>): <mô tả ngắn>`, scope có thể bỏ qua. Dùng `feat`, `fix`, `docs`, `test`, `refactor`, `chore` hoặc `ci` theo nội dung công việc.

Ví dụ: `feat(backend): add login API`, `fix(frontend): show login error`, `docs: update setup guide`.

## Bật yêu cầu PR và CI trên GitHub

File JSON chỉ là cấu hình chuẩn bị sẵn. Chủ repo phải import theo [docs/GITHUB_SETUP.md](docs/GITHUB_SETUP.md) để GitHub bắt buộc PR/CI và chặn force push/xóa hai nhánh dài hạn.
