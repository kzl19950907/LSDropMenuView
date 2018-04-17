[TOC]


* ### SDWebImage的基本使用  

给imageView设置图片    
```
[bImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder"]];   
```
接下来调用到方法,我们一步一步分析每行代码分别做了什么操作。
```
-(void)sd_internalSetImageWithURL:(nullable NSURL *)url
placeholderImage:(nullable UIImage *)placeholder
options:(SDWebImageOptions)options
operationKey:(nullable NSString *)operationKey
setImageBlock:(nullable SDSetImageBlock)setImageBlock
progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
completed:(nullable SDExternalCompletionBlock)completedBlock
context:(nullable NSDictionary<NSString *, id> *)context
```
validOperationKey代表的是存放UIView中所有optration的key,如果没有就以当前类class作为key。

```
NSString *validOperationKey = operationKey?:NSStringFromClass([self class]);    
```

调用cancle方法,通过key取消当前所有的图片加载操作。首先获取view中的oprationDictionary,找到当前key对应的operation 并调用cancle,从 oprationDictionary移除当前操作key。
```
[self sd_cancelImageLoadOperationWithKey:validOperationKey];

- (void)sd_cancelImageLoadOperationWithKey:(nullable NSString *)key {
// Cancel in progress downloader from queue
SDOperationsDictionary *operationDictionary = [self sd_operationDictionary];
id<SDWebImageOperation> operation;
@synchronized (self) {
operation = [operationDictionary objectForKey:key];
}
if (operation) {
if ([operation conformsToProtocol:@protocol(SDWebImageOperation)]){
[operation cancel];
}
@synchronized (self) {
[operationDictionary removeObjectForKey:key];
}
}
}
```

* ###### SDOperationsDictionary介绍
```
typedef NSMapTable<NSString *, id<SDWebImageOperation>> SDOperationsDictionary;
```
从定义来看 SDoperationDictionary是一个NSMaptable泛型,类似于而NSMaptable是什么一个类呢？
* ###### [NSMapTable](http://www.isaced.com/post-235.html)
NSMapTable 是一个map集合 即可以处理 key->obj映射,也可以处理 obj->obj映射。(NSDictionary只提供了key->obj映射,本质上来讲obj的位置是有key来索引的,并且NSDictionary会复制key到自己的私有空间,key需要遵从NSCopying协议,key应该是小且高效的，以至于复制的时候不会对 CPU 和内存造成负担。)
```
//key copy  value strong 构造的NSMapTable对象和NSMutableDictionary用起来类似 复制key 并且强引用obj
NSMapTable *keyToObjectMapping = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableStrongMemory];
```   
再回来看SDOperationsDictionary的get方法,为UIView动态添加属性sd_operationDictionary     
```
-(SDOperationsDictionary *)sd_operationDictionary{
@synchronized(self) {
SDOperationsDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
if (operations) {
return operations;
}
//key strong obj weak
operations = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
return operations;
}
}
```



