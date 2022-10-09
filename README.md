# GithubUserProfileWithMVVM

## 🍎 작동 화면

|              작동 화면               |
|:------------------------------------:|
| ![](https://i.imgur.com/kTwYWX5.gif) |
- MVC 구조에서 MVVM 구조로 변경 되었을 뿐 기능이 변경된것은 아니라 이전 GithubUserProfile 프로젝트의 작동화면과 동일.


## 🍎 MVC와 MVVM 구조적 차이점
- **먼저 당연한 것이지만 두 프로젝트 모두 동일한 작동을 한다.**
- **GithubUserProfile**
    - ViewController내,
        - 유저의 입력으로 진행되는 네트워크 로직
        - 퍼블리셔를 업데이트하는 로직
        - 퍼블리셔로 부터 받아온 값에 따라 업데이트하는 로직
- **GithubUserProfileWithMVVM**
    - ViewModel을 만들어 네트워크, 모델 관련 로직을 담당하게 하고, View에서는 UI관련 로직 이외에는 '보여주기'를 목적으로 설계.
    - 다만, 'UI를 업데이트하는 코드'이더라도 가공해 사용하는 부분이 있다면 ViewModel에서 처리하고 View로 넘겨주자!
        - 퍼블리셔와 로직 모두 ViewModel로 이전해 해당 프로젝트에서 View 역할을 맡고 있는 SearchViewController는 화면을 보여주는 역할만 맡고있다.

## 🍎 flow chart로 나타낸 차이점
### GithubUserProfile 프로젝트에서 사용한 MVC 패턴
![](https://i.imgur.com/OyQLXFp.png)
- 이 모든 과정이 SearchViewController내에서 일어나고 있어 추후 새로운 기능을 추가하거나 유지보수, 측면에서 좋지 않음.

### GithubUserProfileWithMVVM 프로젝트에서 사용한 MVVM 패턴
![](https://i.imgur.com/c78lPwC.png)
- SearchViewController내에서 네트워크 또는 모델을 가공하는 작업들을 모두 ViewModel로 이전해 최대한 '화면을 보여주는 역할'에 충실할 수 있도록 역할을 분담.

## 🍎 SearchViewController내 Bind() 메서드
- 현재 코드에서 Bind 메서드를 보면 아래와 같이 되어있다.
```swift
private func bind() {
    viewModel.selectedUser
        .receive(on: RunLoop.main)
        .sink { [unowned self] _ in
            self.nameLabel.text = self.viewModel.name
            self.loginLabel.text = self.viewModel.login
            self.followerLabel.text = self.viewModel.follower
            self.followingLabel.text = self.viewModel.following
            self.firstDateLabel.text = self.viewModel.firstDate
            self.latestUpdateLabel.text = self.viewModel.latestUpdate
            self.thumbnail.kf.setImage(with: self.viewModel.avatarUrl)
        }.store(in: &subscriptions)
}
```
- 처음 화면이 띄워질 때, 위의 메서드가 실행되고 파이프라인까지 구축해줘, CurrentValueSubject 타입의 퍼블리셔가 바뀔때 마다 자동으로 실행된다.

## 🍎 부족한 부분 (추후 공부 후 정리 링크 업데이트 예정)
- 네트워크의 dataTaskPublisher와 tryMap의 활용.


