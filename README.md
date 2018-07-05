## Minimum Viable Architecture


Refactoring the example project from Jon Bott`s course at Linkedin Learning - [Common Architectures Comparison](https://www.linkedin.com/learning/ios-app-development-design-patterns-for-mobile-architecture/common-architectures-comparison). In this mini course, him show the differences and similarities pieces between common architectures - MVC, MVP, MVVM, VIPER - Explaining everything in a idea of *M*inimum *V*iable *A*rchitecture - MVA.

I've...
- [x] replaced Outlaw Pod by Codable protocol;
- [x] removed Swinject and SwinjectStoryboard Pods - Because I see no benefit in maintaining such a strong dependency on these libraries when we have the power of Swift protocols - Here a [great article](https://medium.com/makingtuenti/dependency-injection-in-swift-part-1-236fddad144a) from Juan Cazalla talking about this;
- [x] moved viewControllers from storyboard to individual nibs;

---

The original project has be in original-ch7-02 branch.
