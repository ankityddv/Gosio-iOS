//
//  zip3sequence.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

public func zip<
Sequence1 : Sequence,
Sequence2 : Sequence,
Sequence3 : Sequence
>(
  _ sequence1: Sequence1,
  _ sequence2: Sequence2,
  _ sequence3: Sequence3

) -> Zip3Sequence<
Sequence1,
Sequence2,
Sequence3
> {
  return Zip3Sequence(
    _sequence1: sequence1,
    _sequence2: sequence2,
    _sequence3: sequence3
  )
}

/// An iterator for `Zip3Sequence`.
public struct Zip3Iterator<
  Iterator1 : IteratorProtocol,
  Iterator2 : IteratorProtocol,
  Iterator3 : IteratorProtocol
> : IteratorProtocol {
  /// The type of element returned by `next()`.
  public typealias Element = (
      Iterator1.Element,
      Iterator2.Element,
      Iterator3.Element
  )

  /// Creates an instance around the underlying iterators.
  internal init(
      _ iterator1: Iterator1,
      _ iterator2: Iterator2,
      _ iterator3: Iterator3
  ) {
    _baseStream1 = iterator1
    _baseStream2 = iterator2
    _baseStream3 = iterator3
  }

  
  public mutating func next() -> Element? {
    

    if _reachedEnd {
      return nil
    }

    guard
        let element1 = _baseStream1.next(),
        let element2 = _baseStream2.next(),
        let element3 = _baseStream3.next()
    else {
      _reachedEnd = true
      return nil
    }

    return (
        element1,
        element2,
        element3
    )
  }

  internal var _baseStream1: Iterator1
  internal var _baseStream2: Iterator2
  internal var _baseStream3: Iterator3
  internal var _reachedEnd: Bool = false
}

public struct Zip3Sequence<
Sequence1 : Sequence,
Sequence2 : Sequence,
Sequence3 : Sequence
>
  : Sequence {

  public typealias Stream1 = Sequence1.Iterator
  public typealias Stream2 = Sequence2.Iterator
  public typealias Stream3 = Sequence3.Iterator

  
  public typealias Iterator = Zip3Iterator<
    Stream1,
    Stream2,
    Stream3
>

  @available(*, unavailable, renamed: "Iterator")
  public typealias Generator = Iterator

 
  public // @testable
  init(
    _sequence1 sequence1: Sequence1,
    _sequence2 sequence2: Sequence2,
    _sequence3 sequence3: Sequence3
  ) {
    _sequence1 = sequence1
    _sequence2 = sequence2
    _sequence3 = sequence3
  }

  /// Returns an iterator over the elements of this sequence.
  public func makeIterator() -> Iterator {
    return Iterator(
      _sequence1.makeIterator(),
      _sequence2.makeIterator(),
      _sequence3.makeIterator()
    )
  }

  internal let _sequence1: Sequence1
  internal let _sequence2: Sequence2
  internal let _sequence3: Sequence3
}
