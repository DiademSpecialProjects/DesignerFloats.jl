struct OnOverflow{T} end

const OverflowToInf = OnOverflow{:Inf}()
const OverflowToNaN = OnOverflow{:NaN}()
const OverflowToMax = OnOverflow{:Max}() # Saturation

