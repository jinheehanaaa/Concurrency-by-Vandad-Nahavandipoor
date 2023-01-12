# Objective
- Concurrency
- Returning a package (or Future)
- Future performs asynchronous tasks
- Async/Await is required to open a package (or Future) to see what's inside Future

# Requirements
- [Live Server Extension] for parsing JSON
- Use 10.0.2.2 instead of localhost for android emulator

# Understand Pipelin in parseJson(){}
``` dart (
    Future<Iterable<Person>> parseJson(String url) => HttpClient()
    .getUrl(Uri.parse(url)) // 1st pipe to create request Future
    .then((req) => req.close()) // Take req
    .then((resp) => resp.transform(utf8.decoder).join()) // Create response pipe & parse it as string
    .then((str) => json.decode(str) as List<dynamic>) // Take string & parse it as json
    .then((json) => json.map((e) => Person.fromJson(e))); // json is split into various instances of Person class to become Future<Iterable> type
)
```

# Flow
## Step 1. Future & Async, Await
- Function returning Future 
- - doesn't calculate its content inside the function itself
- - Packages execution code to be called by the caller later in the future
- - Only calculates the return (ex: Iterable<Person>)
- - Other function should read its content
- Function returning Async
- - await on the result for whoever called this function
- - and give the result back to that function
- async is a way to mark your function as being able to use await syntax
- await can wait on the result of Future in a function marked with async
- Think parseJson function as pipeline
- - 1st pipeline => Get URL with REQUEST Pipe
- - 2nd pipeline => Parse json as string with Response Pipe

## Step 2. Multiple APIs, Error handling entire Future
- <Iterable<Person>>: List of person
- <List<Iterable<Person>>>: More than 1 API, list of list of people
- Future<List<Iterable<Person>>>>: Package of list of list of people
- Error Handling using catchError (Ignore dynamic & stack trace for now)
- - Make Custom extension for catching error "emptyOnError" to spit out empty Iterable list if one or more Future fails to parse

## Step 3.Error handling per future
- You can still display correct api even if other api has error.

## Step 4. forEach
- Test for valid url
- Mark failed url
- Useful if you are calling multiple calls to your backend
- Use Future.wait: If you want the result of Future.
- Use Future.forEach: If you don't care about the result.

## Step 5. Stream
- Asynchronous generator (async*): 
- - returns Stream<T>
- - Useful for performing series of operations
- Strean is continuous pipe of information. (Can produce more than 1 value)
- Future is just 1 pipe of information.
- Use await for for reading result of Stream

## Step 6. API end points
- Create JSON that will define end point (instead of hardcoding)
- ListOfThingsAPI<T> for parsing content of apis.json (List of Iterable Stream)
- async marks the function as being able to use await keyword inside the function.
- *async is asynchronous generator => We return Stream using yield.

## Step 7. Stream
- Streams allow asynchronous expansion. (Think about git's branch & merge)
- You can take advantage of asyncExpand in your normal stream to make asynchronous API call on asynchronous Stream.

## Step 8. Stream transformation
- EventSink: data holder
- StreamTransformerBase: Middleman for EventSink & Stream
- Transformer returns Stream

# Resources
- [Concurrency Tutorial](https://youtu.be/Rs9i8zJhN68)
- [RxJS Marbles for visualizing Stream](https://rxmarbles.com/)