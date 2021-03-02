//
//  Zip6Sequence.swift
//  Gosio
//
//  Created by ANKIT YADAV on 01/03/21.
//


public func zip<
Sequence1 : Sequence,
Sequence2 : Sequence,
Sequence3 : Sequence,
Sequence4 : Sequence,
Sequence5 : Sequence,
Sequence6 : Sequence
>(
  _ sequence1: Sequence1,
  _ sequence2: Sequence2,
  _ sequence3: Sequence3,
  _ sequence4: Sequence4,
  _ sequence5: Sequence5,
  _ sequence6: Sequence6

) -> Zip6Sequence<
Sequence1,
Sequence2,
Sequence3,
Sequence4,
Sequence5,
Sequence6
> {
  return Zip6Sequence(
    _sequence1: sequence1,
    _sequence2: sequence2,
    _sequence3: sequence3,
    _sequence4: sequence4,
    _sequence5: sequence5,
    _sequence6: sequence6
  )
}

/// An iterator for `Zip6Sequence`.
public struct Zip6Iterator<
  Iterator1 : IteratorProtocol,
  Iterator2 : IteratorProtocol,
  Iterator3 : IteratorProtocol,
  Iterator4 : IteratorProtocol,
  Iterator5 : IteratorProtocol,
  Iterator6 : IteratorProtocol
> : IteratorProtocol {
  /// The type of element returned by `next()`.
  public typealias Element = (
      Iterator1.Element,
      Iterator2.Element,
      Iterator3.Element,
      Iterator4.Element,
      Iterator5.Element,
      Iterator6.Element
  )

  /// Creates an instance around the underlying iterators.
  internal init(
      _ iterator1: Iterator1,
      _ iterator2: Iterator2,
      _ iterator3: Iterator3,
      _ iterator4: Iterator4,
      _ iterator5: Iterator5,
      _ iterator6: Iterator6
  ) {
    _baseStream1 = iterator1
    _baseStream2 = iterator2
    _baseStream3 = iterator3
    _baseStream4 = iterator4
    _baseStream5 = iterator5
    _baseStream6 = iterator6
  }
    
  public mutating func next() -> Element? {

    if _reachedEnd {
      return nil
    }

    guard
        let element1 = _baseStream1.next(),
        let element2 = _baseStream2.next(),
        let element3 = _baseStream3.next(),
        let element4 = _baseStream4.next(),
        let element5 = _baseStream5.next(),
        let element6 = _baseStream6.next()
    else {
      _reachedEnd = true
      return nil
    }

    return (
        element1,
        element2,
        element3,
        element4,
        element5,
        element6
    )
  }

  internal var _baseStream1: Iterator1
  internal var _baseStream2: Iterator2
  internal var _baseStream3: Iterator3
  internal var _baseStream4: Iterator4
  internal var _baseStream5: Iterator5
  internal var _baseStream6: Iterator6
  internal var _reachedEnd: Bool = false
}

public struct Zip6Sequence<
Sequence1 : Sequence,
Sequence2 : Sequence,
Sequence3 : Sequence,
Sequence4 : Sequence,
Sequence5 : Sequence,
Sequence6 : Sequence
>
  : Sequence {

  public typealias Stream1 = Sequence1.Iterator
  public typealias Stream2 = Sequence2.Iterator
  public typealias Stream3 = Sequence3.Iterator
  public typealias Stream4 = Sequence4.Iterator
  public typealias Stream5 = Sequence5.Iterator
  public typealias Stream6 = Sequence6.Iterator

    
  public typealias Iterator = Zip6Iterator<
    Stream1,
    Stream2,
    Stream3,
    Stream4,
    Stream5,
    Stream6
>

  @available(*, unavailable, renamed: "Iterator")
  public typealias Generator = Iterator

    
  public // @testable
  init(
    _sequence1 sequence1: Sequence1,
    _sequence2 sequence2: Sequence2,
    _sequence3 sequence3: Sequence3,
    _sequence4 sequence4: Sequence4,
    _sequence5 sequence5: Sequence5,
    _sequence6 sequence6: Sequence6
  ) {
    _sequence1 = sequence1
    _sequence2 = sequence2
    _sequence3 = sequence3
    _sequence4 = sequence4
    _sequence5 = sequence5
    _sequence6 = sequence6
  }

  /// Returns an iterator over the elements of this sequence.
  public func makeIterator() -> Iterator {
    return Iterator(
      _sequence1.makeIterator(),
      _sequence2.makeIterator(),
      _sequence3.makeIterator(),
      _sequence4.makeIterator(),
      _sequence5.makeIterator(),
      _sequence6.makeIterator()
    )
  }

  internal let _sequence1: Sequence1
  internal let _sequence2: Sequence2
  internal let _sequence3: Sequence3
  internal let _sequence4: Sequence4
  internal let _sequence5: Sequence5
  internal let _sequence6: Sequence6
}
