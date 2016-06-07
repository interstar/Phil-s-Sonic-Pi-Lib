# Phil's Library 0.1

# lib.txt
# Contains

# Classes
# Part

# functions
# section_for


class Part
  def calclen(notes,sleeps)
    if sleeps.size() > notes.size()
      return sum_array(sleeps.take notes.size())
    else
      return calclen(notes,sleeps*2)
    end
  end
  
  attr_reader :melody
  attr_reader :rhythm
  attr_reader :instrument
  attr_reader :vols
  
  def initialize(mel, rhyth, vols, playblock )
    @melody = mel
    @rhythm = rhyth
    @vols = vols
    @maxlen = [mel.length,rhyth.length].max
    @time = calclen(mel,rhyth)
    @p_block = playblock
    start_play()
  end
  
  def start_play()
    @mi = 0
    @ri = 0
    @vi = 0
    @counter = 0
  end
  
  def sum_array(xs)
    sum = 0
    xs.each { |a| sum+=a }
    return sum
  end
  
  def length()
    return @time
  end
  
  def has_next()
    return @counter < @maxlen
  end
  
  
  def next_()
    val = {:note=>@melody[@mi],:sleep=>@rhythm[@ri],:amp=>@vols[@vi],:mi=>@mi,:ri=>@ri,:vi=>@vi}
    
    @mi+=1
    if @mi >= @melody.length
      @mi = 0
    end
    
    @ri+=1
    if @ri >= @rhythm.length
      @ri = 0
    end
    
    @vi+=1
    if @vi >= @vols.length
      @vi = 0
    end
    
    return val
  end
  
  def play_with_block()
    if not @p_block then
      # can't do anything more sensible because the only reason we're passing
      # p_block from outside is to access the sonic-pi stuff in its scope
      return
    end
    
    start_play()
    
    loop do
      if (not has_next()) then
        break
      end
      n=next_()
      @p_block.call(n)
    end
  end
end

# Functions
# ______________________________

def wait_then(x,a)
  sleep m(x)
  return a
end

def m(x)
  x*60
end


def tri_env(max,fade_in,hold,fade_out)
  return (line 0, max, steps: fade_in) + [max]*hold + (line max, 0, steps: fade_out)
end
