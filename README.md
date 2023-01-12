# Objective
- Concurrency
- Returning a package (or Future)
- Future performs asynchronous tasks
- Async/Await is required to open a package (or Future) to see what's inside Future

# Requirements
- [Live Server Extension] for parsing JSON
- Use 10.0.2.2 instead of localhost for android emulator

# Tip


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



# Resources
- [Concurrency Tutorial](https://youtu.be/Rs9i8zJhN68)
