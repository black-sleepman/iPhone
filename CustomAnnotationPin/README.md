###MapViewにカスタマイズしたピンを立てる
デフォルトのピンには規定のデータしか持たせることができないが
ピンクラスを自作することで個々のピンに様々なデータを持たせることができるようになる
- デフォルト
```swift
var myPin: MKPointAnnotation = MKPointAnnotation()
myPin.coordinate = center
myPin.title = "タイトル"
myPin.subtitle = "サブタイトル"
myMapView.addAnnotation(myPin)
```
- カスタムクラスを用いたピン
```swift
/* カスタムピンに持たせるデータ群 */
class CustomAnnotation: MKPointAnnotation {
  var string: String!
}

let Annotation = CustomAnnotation()
Annotation.coordinate = CLLocationCoordinate2DMake(36.0665693, 136.2173733)
Annotation.title = "ここにタイトルが入ります"
Annotation.subtitle = "ここにサブタイトルが入ります"
Annotation.string = "各Pinに個別のデータを持たせることができます"
```

