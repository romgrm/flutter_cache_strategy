# flutter_cache_strategy

A package to implement a complete caching strategy to handle the display of data for your users.

## Usage (WIP) 

You can refer to the `example` folder to know how to implement the 
package. 

First you need to inject the `CacheStrategyPackage()` (it's a Singleton)

Then, you can call `execute()` method and inject the parameters required depending on the strategy choosen (`boxeName`,`async`, `serializer`...)

You can use 4 differents strategies : 

- **AsyncOrCacheStrategy** which will first trigger a remote call to retrieve the data and store it in the device's cache. If the call generates an error at any point, the data in the cache will be retrieved.
- **CacheOrAsyncStrategy** works in reverse to the above strategy, looking for cached data first and if null is returned then a remote call is triggered. 

- **JustAsyncStrategy** will only trigger a remote call to retrieve data.

- **JustCacheStrategy** will only fetch cached data.

And that's all ! 

## Example

- When it's set on AsyncOrCacheStrategy : 
// image 

- When you cut internet, always set on AsyncOrCacheStrategy : 
// same image above

- Now click on Remove French food from cache : 
// image wihtout french food 

you see now the french food is remove from the Boxe in cache but Italian food is still here 

- Now if you click on Remove European food from cache 
// image without european food 
 you have not data in this boxe in cache but you have data in indian boxe because it's 2 differents boxes. 

## Article/ Resources

This package is the completion of that [article](https://medium.com/@romaingreaume/implementing-a-cache-strategy-in-your-flutter-app-5db3e316e7c9) who I wrote. 
## Pull requests
Pull requests are welcome, I'm a beginner so don't hesitate if you see any corrections.




## Additional information

- https://github.com/romgrm/flutter_cache_strategy