# Проект для развития навыков
 ## Что используется:
- Взаимодействие с Api через Alamofire 
- Хранение значений в CoreData
- TableView, CollectionView
- Adaptive layout на экране логина 
- GoogleMap (не много) 
- Kingfisher для взаимодействием с image
- Почти MVP
- Locksmith
- CoreAnimating
- Local PushNotification
## Что с ним не так: 
- MVP корявый(взаимодействие с UIKit в презентере, рефактор с MVC->MVP не до конца)
- Headers конфигурации для таблиц были перенесены в отдельные классы, но выкрученны в синглтоны ради селектора
- Мелкие поведенческие баги визуального формата
