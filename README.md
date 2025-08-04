# PineApple

PineApple은 인기 있는 음악, 영화, 팟캐스트를 탐색하고 iTunes API를 통해 콘텐츠를 검색할 수 있는 iOS 애플리케이션입니다.

## 주요 기능

- **인기 콘텐츠 탐색**: 인기 음악, 영화, 팟캐스트 목록을 제공합니다.
- **콘텐츠 검색**: 영화 및 팟캐스트를 검색할 수 있습니다.
- **계절별 음악 추천**: 봄, 여름, 가을, 겨울에 어울리는 음악을 추천합니다.
- **반응형 UI**: ReactorKit을 활용한 반응형 프로그래밍으로 사용자 경험을 향상시킵니다.
- **유연한 UI 레이아웃**: `UICollectionViewCompositionalLayout`을 사용하여 다양한 화면에 최적화된 레이아웃을 제공합니다.
- **의존성 주입**: `DIContainer`를 통해 의존성을 관리하여 모듈성과 테스트 용이성을 높입니다.

## 아키텍처 및 기술 스택

- **아키텍처**: 클린 아키텍처 기반 (Presentation, Domain 계층 분리)
  - **Presentation Layer**: ReactorKit (Reactor, View, ViewController)을 사용하여 UI 및 사용자 상호작용을 반응형으로 처리합니다. Reactor는 View의 상태를 관리하고 비즈니스 로직을 Domain 계층의 UseCase에 위임합니다.
  - **Domain Layer**: 애플리케이션의 핵심 비즈니스 로직을 포함합니다. `UseCase`는 특정 비즈니스 규칙을 캡슐화하며, `Entities`는 도메인 모델을 정의합니다.
- **네트워킹**: Moya를 사용하여 iTunes API와 통신합니다. RxMoya를 통해 RxSwift와 통합되어 비동기 네트워크 요청을 효율적으로 처리합니다.
- **반응형 프로그래밍**: RxSwift와 RxCocoa를 활용하여 비동기 이벤트 스트림을 처리하고 UI 바인딩을 구현합니다.
- **UI 레이아웃**: SnapKit을 사용하여 Auto Layout 제약을 코드로 쉽게 정의하며, `UICollectionViewCompositionalLayout`으로 복잡하고 유연한 컬렉션 뷰 레이아웃을 구성합니다.
- **객체 초기화**: Then 라이브러리를 사용하여 객체 초기화 코드를 간결하고 가독성 있게 작성합니다.
- **화면 전환 애니메이션**: Hero 라이브러리를 사용하여 뷰 컨트롤러 간의 전환 애니메이션을 부드럽고 다이내믹하게 구현합니다.
- **API**: iTunes API를 통해 음악, 영화, 팟캐스트 데이터를 가져옵니다.

## 프로젝트 구조

```
PineApple/
├───App/                  # 애플리케이션의 진입점, 앱 생명주기 관리, 그리고 DIContainer를 통한 전역 의존성 주입을 설정합니다.
│   ├───AppDelegate.swift
│   ├───DIContainer.swift
│   └───SceneDelegate.swift
├───Domain/               # 클린 아키텍처의 핵심 계층으로, 순수한 비즈니스 로직과 도메인 엔티티를 정의합니다.
│   ├───Entities/         # API 응답을 매핑하는 데이터 모델 및 도메인 엔티티를 포함합니다.
│   │   ├───Contents.swift
│   │   ├───ItunesAPI.swift
│   │   ├───MovieList.swift
│   │   ├───PodcastList.swift
│   │   └───SongList.swift
│   ├───Repositories/     # 데이터 소스 추상화를 위한 프로토콜을 정의합니다. (현재는 비어있음)
│   └───UseCase/          # 특정 비즈니스 로직을 수행하는 UseCase(인터랙터)를 정의합니다.
│       ├───PopularMovieUseCase.swift
│       ├───PopularPodcastUseCase.swift
│       ├───PopularSongsUseCase.swift
│       └───SearchUseCase.swift
├───Extensions/           # 프로젝트 전반에 걸쳐 사용되는 유틸리티 확장 기능을 포함합니다.
│   └───Reactive+.swift
├───Network/              # 외부 API와의 통신을 담당하는 네트워크 계층입니다. Moya를 사용하여 API 정의 및 요청을 처리합니다.
│   └───ItunesAPIImpl.swift
└───Presentation/         # 사용자 인터페이스와 사용자 상호작용을 담당하는 UI 계층입니다. ReactorKit 패턴을 따릅니다.
    ├───Components/       # 재사용 가능한 UI 컴포넌트 (예: 커스텀 셀, 헤더 뷰)를 포함합니다.
    │   ├───horizonCell.swift
    │   └───SectionHeaderView.swift
    ├───MoviePodcast/     # 영화 및 팟캐스트 관련 화면의 View, ViewController, Reactor를 포함합니다.
    │   ├───MoviePodcastReactor.swift
    │   ├───MoviePodcastView.swift
    │   └───MoviePodcastViewCotroller.swift
    └───Music/            # 음악 관련 화면의 View, ViewController, Reactor를 포함합니다.
        ├───MusicReactor.swift
        ├───MusicView.swift
        └───MusicViewController.swift
```
