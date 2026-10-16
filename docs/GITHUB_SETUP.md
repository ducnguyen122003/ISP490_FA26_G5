# Bật bảo vệ main và develop

## Phần đã chuẩn bị trong Git

Repository dùng `develop` để tích hợp và `main` cho bản ổn định. Workflow CI, mẫu PR/issue và Ruleset JSON nằm trong mã nguồn. **Commit JSON không tự bật bảo vệ nhánh.** Chủ repo phải import cấu hình trong Settings hoặc dùng GitHub CLI có quyền quản trị.

Plugin GitHub được dùng trong lần thiết lập này có thể tạo nhánh/commit/PR nhưng không có công cụ ghi Branch Protection/Rulesets. Vì vậy chỉ coi việc khóa nhánh hoàn tất sau khi đã import và kiểm tra trên GitHub.

## Các bước thực hiện

1. Kiểm tra PR thiết lập `develop` → `main`; dùng **Create a merge commit** khi CI đạt. Giữ nhánh `develop` sau khi merge.
2. Mở [file main-develop.json](https://github.com/ducnguyen122003/doantotnghiep/blob/develop/.github/rulesets/main-develop.json), chọn **Download raw file** để tải JSON.
3. Mở [Settings → Rules → Rulesets](https://github.com/ducnguyen122003/doantotnghiep/settings/rules).
4. Chọn **New ruleset → Import a ruleset**, chọn file JSON.
5. Kiểm tra Enforcement là **Active**, target gồm `main` và `develop`, sau đó **Create**.
6. Xác nhận ba required checks: **Branch policy**, **Project layout**, **CI result**, nguồn là GitHub Actions.

Ruleset yêu cầu PR và CI thành công, cập nhật với base, giải quyết review thread; chặn force push và xóa hai nhánh. Không có bypass actor nên quản trị viên cũng tuân theo rule.

Mặc định **0 approval bắt buộc** để người làm một mình không bị khóa; vẫn phải mở PR và đạt CI. Khi nhóm có ít nhất hai người có quyền review, đổi Required approvals thành **1**. Tác giả không thể tự duyệt PR của mình.

Hai check build module không được đặt trực tiếp thành required vì source hiện chưa có. **CI result** tổng hợp chúng: khi module đã có, build lỗi/bị hủy/bị skip bất thường sẽ chặn merge; khi module chưa có, job tương ứng được skip và báo rõ chưa build.

## Cách khác bằng PowerShell và GitHub CLI

Chỉ làm một trong hai cách. Nếu đã import trên giao diện thì không chạy POST lần nữa để tránh tạo ruleset trùng. Sau khi cài GitHub CLI, từ thư mục gốc checkout có file JSON:

```powershell
gh auth login
Get-Content .github/rulesets/main-develop.json -Raw | gh api --method POST repos/ducnguyen122003/doantotnghiep/rulesets --input -
gh api repos/ducnguyen122003/doantotnghiep/rulesets
```

Tài khoản đăng nhập phải có quyền quản trị repository. Không đưa token vào file trong Git.

## Cấu hình merge

Trong [Settings → General](https://github.com/ducnguyen122003/doantotnghiep/settings), giữ **Allow squash merging** và **Allow merge commits**. Giữ default branch là `main`; PR công việc chọn base `develop`.

Chỉ xóa thủ công nhánh công việc đã hoàn tất. Không bật xóa nhánh tự động khi chưa có cơ chế giữ `develop`, vì nó có thể bị xóa sau PR `develop` → `main`.

Sau phát hành/hotfix, mở PR `main` → `develop` và dùng merge commit để đồng bộ lịch sử/bản sửa lỗi. Toàn bộ lệnh thực hành ở [CONTRIBUTING.md](../CONTRIBUTING.md).

Tài liệu chính thức: [quản lý/import ruleset](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/managing-rulesets-for-a-repository), [REST API rulesets](https://docs.github.com/en/rest/repos/rules#create-a-repository-ruleset).
