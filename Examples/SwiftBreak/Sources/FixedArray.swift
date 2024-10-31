import Builtin

@frozen
public struct Vector<let Count: Int, Element: ~Copyable>: ~Copyable {
    private var storage: Builtin.FixedArray<Count, Element>
}

extension Vector where Element: ~Copyable {
    init(first: @autoclosure ()->Element, rest valueForIndex: (borrowing Element) -> Element) {
        storage = Builtin.emplace { rawPointer in
            let first = first()
            let base = UnsafeMutablePointer<Element>(rawPointer)
            for i in 1..<Count {
                (base + i).initialize(to: valueForIndex(first))
            }
            base.initialize(to: first)
        }
    }
}

extension Vector where Element: ~Copyable {
    public subscript(i: Int) -> Element {
        _read {
            assert(i >= 0 && i < Count)
            let rawPointer = Builtin.addressOfBorrow(self)
            let base = UnsafePointer<Element>(rawPointer)
            yield ((base + i).pointee)
        }
        
        _modify {
            assert(i >= 0 && i < Count)
            let rawPointer = Builtin.addressof(&self)
            let base = UnsafeMutablePointer<Element>(rawPointer)
            yield (&(base + i).pointee)
        }
    }
    
    func forEach(_ body: (borrowing Element) -> Void) {
      for i in 0..<Count {
        body(self[i])
      }
    }

    func enumerated(_ body: (Int, borrowing Element) -> Void) {
      for i in 0..<Count {
        body(i,self[i])
      }
    }
    
    var count: Int { Count }
}

