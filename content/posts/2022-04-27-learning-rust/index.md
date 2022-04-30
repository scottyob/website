---
title: 'learning-rust'
type: post
author: scottyob
date: 2022-04-27
categories:
 - programming
tags:
 - rust

---

## Why learn Rust?
In Network Engineering at ~~Facebook~~ Meta, we've been going through an interesting transformation in which we're starting to be discouraged to write new services in Python, and, instead start writing more in Rust (and sorry Golang, of which we've already got a bit written in.

I've always said that I'm not overly a smart person (though am stubborn enough to solve most problems), and don't expect to be able to pick it up quickly, I decided to start learning by challenge tasks, do as much as I can in it, and document some here.

For my challenges, I'm going to use Project Euler and compare my solutions in Python and Rust.  Python because it's my most comfortable language.

## Challenges
### Multiples of 3 or 5
This one threw me slightly.  Nice and easy to play with iterators, but I don't get why I needed to give it a type in rust.  I'd have thought the range might have been smart enough to infer the type?

Python:
```
print(sum(x for x in list(range(1,1000)) if x % 3 == 0 or x % 5 == 0 ))
```

Rust:
```
fn main() {
    let sum: i32 = (1..1000).filter(|x| x % 3 == 0 || x % 5 == 0).sum();
        println!("{}", sum);
        
}
```

### Question 2
```
 a = 1
 b = 2
 total = 2
 while 1:
     c = a + b
     if c > 4000000:
         break
     if c % 2 == 0:
         total += c
     a = b
     b = c
 print(total)
```

