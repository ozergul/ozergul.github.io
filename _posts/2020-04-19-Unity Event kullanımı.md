Merhaba arkadaşlar. Bugünkü yazımda sizlere Unity'nin faydalı bir özelliğinden bahsedeceğim: [UnityEvent](https://docs.unity3d.com/ScriptReference/Events.UnityEvent.html)

UnityEvent'i JavaScript'teki callback functionlara benzetiyorum ben. Genelde oyunlarda kurgulanan bir olay sonrası bir action fire etmek için kullanırım. Örneğin generic sayılabilecek bir Dragger scriptimiz olsun. Bu scriptin görevi de şu olsun: 2D item'ı sürüklenebilir yap ve hedef trigger ile etkileşime geçtiğinde hedefi yok et.

Hemen Dragger adında bir script oluşturalım. Yapmamız gereken on drag eventini ve on trigger enter 2D eventini dinlemek:

``` csharp
public class Dragger : MonoBehaviour, IDragHandler  
{  
  public void OnDrag(PointerEventData eventData)  
 {  // TODO: drag  
  }  
  
  void OnTriggerEnter2D(Collider2D col)  
 {  // TODO: trigger  
  }  
}
```

Item'ı sürükler iken biraz yumuşak olmasını istiyorum. O yüzden ``Vector2.SmoothDamp`` ile, tıkladığımız position olan Input.mousePosition değerini smoothTime değeri ile sınırlayacağız.

``` csharp
public float smoothTime = 0.1f;  
private Vector2 velocity = Vector2.zero;  
public bool dragable = true;

public void OnDrag(PointerEventData eventData)  {  
  if (dragable) { 
    var mousePosition = Input.mousePosition;  
    transform.position = Vector2.SmoothDamp(transform.position,  
	    new Vector2(mousePosition.x, mousePosition.y), ref velocity, smoothTime);  
  }
}

```
OnTriggerEnter2D methodunda ise, trigger olan game objesi ile bizim inspector'de verdiğimiz hedef game objesinin name'i aynı mı kıyaslaıyoruz. If koşulunun içine girdiğinde setlediğimiz olduğumuz unity eventi invoke metodu ile çalıştırılacak. Metodun olmaması hata fırlatmaz.

``` csharp
public GameObject target;
public UnityEvent afterTrigger;

void OnTriggerEnter2D(Collider2D col)  
{  
  if (col.transform.name == target.name) {
    afterTrigger.Invoke();  
  }
}
```

Kodlarımızı toparlarsak son hali böyle olacak:

 ``` csharp
public class Dragger : MonoBehaviour, IDragHandler
{
    public GameObject target;
    public bool dragable = true;

    public float smoothTime = 0.1F;
    private Vector2 velocity = Vector2.zero;

    public UnityEvent afterTrigger;

    public void OnDrag(PointerEventData eventData)
    {
        if (dragable)
        {
            var mousePosition = Input.mousePosition;
            transform.position = Vector2.SmoothDamp(transform.position,
                new Vector2(mousePosition.x, mousePosition.y), ref velocity, smoothTime);
        }
    }

    void OnTriggerEnter2D(Collider2D col)
    {
        if (col.transform.name == target.name)
        {
            afterTrigger.Invoke();
        }
    }
}
```

Inspector'de After Collide kısmına artık trigger sonrası çalışmasını istediğiniz fonksiyonu sürükleyebilirsiniz.

![](https://i.imgur.com/70lMgNT.png)

Yukarıdaki [scripti](https://gist.github.com/ozergul/af03e5bb9482636a13b65a01eab1cdac) 2D + Mobile oyunlarınızda kullanabilirsiniz. 

En basit haliyle UnityEvent böyleydi, dökümana bakarak ve hayal gücünüzü kullanarak nasıl kullanacağınız tamamen size kalmış. Kolay gelsin.
