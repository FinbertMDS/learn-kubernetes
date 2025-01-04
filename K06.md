# Deployment triển khai cập nhật và scale

Tạo Deployment, triển khai ứng dụng, thực hiện cập nhật, scale, tự động scale, hủy cập nhật rollback deployment

## Deployment

Deployment quản lý một nhóm các Pod - các Pod được nhân bản, nó tự động thay thế các Pod bị lỗi, hoặc không phản hồi bằng pod mới nó tạo ra. Như vậy, deployment đảm bảo ứng dụng của bạn có một (hay nhiều) Pod để phục vụ các yêu cầu.

Deployment sử dụng mẫu Pod (Pod template - chứa định nghĩa / thiết lập về Pod) để tạo các Pod (các nhân bản replica), khi template này thay đổi, các Pod mới sẽ được tạo để thay thế Pod cũ ngay lập tức.

Thao khảo [Deployment API](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)


1.myapp-deploy.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployapp
spec:
  
  replicas: 2

  selector:
    matchLabels:
      app: deployapp

  template:
    metadata:
      labels:
        app: deployapp
    spec:
      containers:
      - name: node
        image: nginx
        resources:
          limits:
            memory: "128Mi"
            cpu: "150m"
        ports:
        - containerPort: 8085
```
Thực hiện lệnh sau để triển khai
```
kubectl apply -f 1.myapp-deploy.yaml
```
Khi Deployment tạo ra, tên của nó là `deployapp`, có thể kiểm tra với lệnh:
```
kubectl get deploy -o wide
```
Deploy này quản sinh ra một ReplicasSet và quản lý nó, gõ lệnh sau để hiện thị các ReplicaSet
```
kubectl get rs -o wide
```
Đến lượt ReplicaSet do Deploy quản lý lại thực hiện quản lý (tạo, xóa) các Pod, để xem các Pod

```
kubeclt get po -o wide

# Hoặc lọc cả label
kubectl get po -l "app=deployapp" -o wide
```

Thông tin chi tiết về deploy
```
kubectl describe deploy/deployapp
```

## Cập nhật Deployment

Bạn có thể cập một Deployment bằng cách sử đổi mẫu (template) của Pod, khi template cập nhật thì nó tự động triển khai ra các Pod. (sửa file yaml rồi cập nhật với `kubectl apply -f ...` hoặc biên tập trực tiếp với lệnh `kubectl edit deploy/namedeploy`)

Khi một Deployment được cập nhật, thì Deployment dừng lại các Pod, scale lại số lượng Pod về 0, sau đó sử dụng template mới của Pod để tạo lại Pod, Pod cũ không xóa hẳng cho đến khi Pod mới đang chạy, quá trình này diễn ra đến đâu có thể xem bằng lệnh `kubectl describe deploy/namedeploy`. Cập nhật như vậy nó đảm bảo luôn có Pod đang chạy khi đang cập nhật.

Có thể thu hồi lại bản cập nhật bằng cách sử dụng lệnh `kubectl rollout undo`


## Rollback Deployment

Kiểm tra các lần cập nhật (revision)
```
kubectl rollout history deploy/deployapp
```
Để xem thông tin bản cập nhật 1 thì gõ lệnh
```
kubectl rollout history deploy/deployapp --revision=1
```
Khi cần quay lại phiên bản cũ nào đó, ví dụ bản revision 1
```
kubectl rollout undo deploy/deployapp --to-revision=1
```
Nếu muốn quay lại bản cập nhật trước gần nhất
```
kubectl rollout undo deploy/mydeploy
```

## Scale Deployment

Scale thay đổi chỉ số replica (số lượng POD) của Deployment, ý nghĩa tương tự như scale đối với ReplicaSet trong phần trước. Ví dụ để scale với 10 POD thực hiện lệnh:
```
kubectl scale deploy/deployapp --replicas=10
```
Muốn thiết lập scale tự động với số lượng POD trong khoảng min, max và thực hiện scale khi CPU của POD hoạt động ở mức 50% thì thực hiện
```
kubectl autoscale deploy/deployapp --min=2 --max=5 --cpu-percent=50
```

Bạn cũng có thể triển khai Scale từ khai báo trong một yaml. Hoặc có thể trích xuất scale ra để chỉnh sửa
```
kubectl get hpa/deployapp -o yaml > 2.hpa.yaml
```

## Cleanup

```
kubectl delete -f .
```
