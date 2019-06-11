---

layout:  post
title:  Angular ng-template, ng-container ve ng-content nedir?
categories: Angular
---

Merhaba.

Bu yazıda sizlere `<ng-template>`, `<ng-container>` ve `<ng-content>` ten bahsetmek isityorum.

### ng-template

`<ng-template>` HTML'deki `<template>` elemanına benzer. 
 
[MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/template)'deki `<template>` etiketinin tanımı şu şekilde:

> The **HTML Content Template (`<template>`) element** is a mechanism for holding [HTML](https://developer.mozilla.org/en-US/docs/Glossary/HTML "HTML: HTML (HyperText Markup Language) is a descriptive language that specifies webpage structure.") that is not to be rendered immediately when a page is loaded but may be instantiated subsequently during runtime using JavaScript.

HTML'de template'ler siz çağırmadıkça, kullanmadıkça sayfada görünmezler fakat DOM'a yansırlar.
Angular'da ise, Template'ler siz sayfaya çağırmadıkça veya koşul gerçekleşmedikçe sayfada görünmezler, tıpkı HTML'deki `<template>` etiketi gibi. Fakat `<template>` etiketinin DOM'da görünürken, `<ng-template>` lazım olmadıkça DOM'a yansımaz.

`<ng-template>` için Basit bir örnek vermek gerekirse:
``` html
<ng-template>
   Burası bir Template'dir.
</ng-template>
```
Yukarıdaki template Angular tarafından DOM'a basılmayacaktır.

Aşağıdaki örnekte ise `#tmpl1` aslında lokal bir değişkendir ama burada, oluşturmuş olduğumuz Template'in benzersiz idsi olarak görev alır. Bu örnekte `*ngTemplateOutlet` directive'i tarafından sayfa basılır:
``` html
    <ng-template #tmpl1>
       Burası bir Template'dir.
    </ng-template>
    <ng-container *ngTemplateOutlet="tmpl1"></ng-container>
```
`<ng-template>`'in Loading gösterme amaçlı kullanılmasına bazı projelerde denk gelebilirsiniz:
``` html
<div class="items" *ngIf="items else loading">
  ...
</div>

<ng-template #loading>
  <div>Yükleniyor...</div>
</ng-template>
```
`loading` değişkeni dolu olduğu an `<ng-template #loading>` sayfaya basılacaktır.

### ng-container

Az önce bahsettiğimiz `ng-template` sayfaya koşul gerçekleştiğinde yansımasına rağmen `ng-container` her daim sayfaya basılır, sayfaya basmak için herhangi bir koşula gerek yoktur. Fakat DOM'a ekstra bir düğüm eklemeden sadece kendi içeriğini sayfaya basar. (React'taki `<React.Fragment>` gibi.)
``` html
<ng-container>
    Bu yazısı sayfaya basılacaktır.
</ng-container>
```
Aşağıdaki örnek, `items` değişkeninin dolu olduğunu düşünürsek, `ng-container`'ı anlamak için gayet güzel olacak:
``` html
<table>
  <tbody>
    <ng-container *ngFor="let item of items">
    <tr *ngIf="item">
      <td>{{item}}</td>
    </tr>
  </ng-container>
  </tbody>
</table>
```
Aşağıda`<ng-container>` ve `<ng-template>`'in kullanımı hakkında ufak bir örnek mevcut.

[https://stackblitz.com/edit/angular-kgesdb](https://stackblitz.com/edit/angular-kgesdb)

<iframe src="https://stackblitz.com/edit/angular-kgesdb?embed=1&file=src/app/app.component.html" style="width: 100%; height: 500px"></iframe>  

### ng-content
Component'lerinizin içine component vs taşımak için `<ng-content>` kullanılır. En basit örneğiyle:

top.component.ts:
``` typescript
import  {  Component,Input,TemplateRef  }  from  '@angular/core';
@Component({
  selector:  'top-component',
  template:  `
    <div class="wwrapper">
      <ng-content></ng-content>
    </div>
  `,
})
export  class  TopComponent  {
  @Input() template:  TemplateRef<any>;
}
```
Gerekli component'i module dosyanıza import edip kullanmak isterseniz kullanım şu şekilde olacak:
``` html
<top-component>
Bu yazılar wrapper içinde görünecektir.
</top-component>
```
DOM'daki çıktısı şu şekilde olacaktır:
``` html
<div class="wrapper">
Bu yazılar wrapper içinde görünecektir.
</div>
```
Şimdilik bu kadar, görüşmek üzere :)

Kaynaklar:

[http://nataliesmith.ca/blog/ngtemplate-ngcontainer-ngcontent](http://nataliesmith.ca/blog/ngtemplate-ngcontainer-ngcontent)

[https://blog.angular-university.io/angular-ng-template-ng-container-ngtemplateoutlet/](https://blog.angular-university.io/angular-ng-template-ng-container-ngtemplateoutlet/)

[https://angular.io/api/common/NgTemplateOutlet#description](https://angular.io/api/common/NgTemplateOutlet#description)