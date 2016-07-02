# Phil's Library 0.1

# lib.txt
# Contains

# Classes
# Part

# functions
# wait_then
# tri_env
# m
# tri_env_mins
# quad_env_mins
# envp

# pattern_and_shifs
# pattern_and_shift_chords


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
  # turns seconds into minutes.
  x*60
end


def tri_env(max,fade_in,hold,fade_out)
  # returns an "envelope" of values ... fade 0 to max, hold max, fade out max to zero,
  # over the relevant time
  return (line 0, max, steps: fade_in) + [max]*hold + (line max, 0, steps: fade_out)
end

def tri_env_mins(max,fade_in,hold,fade_out,div)
  # returns the same envelope of values as tri_env, but now
  # fade_in, hold and fade_out are time in minutes,
  # and div is the "sleep" time (eg. 0.5 = half second)
  m = 60.0/div
  return tri_env(max,fade_in*m,hold*m,fade_out*m)
end

def quad_env_mins(max,wait,fade_in,hold,fade_out,div)
  # like tri_env_mins but with a period of silence on the front
  m = 60.0/div
  return [0] * (wait * m) + tri_env_mins(max,fade_in,hold,fade_out,div)
end

def envp(div,*all)
  build = []
  i = 0
  val = 0
  m = 60.0/div
  loop do
    break if i >= all.length
    if all[i] == :w
      # wait
      build += ([val] * (all[i+1] * m))
      i = i + 2
    elsif all[i] == :j
      # jump to value and wait for a time
      val = all[i+1]
      build += [val] * (all[i+2] * m)
      i = i + 3
    elsif all[i] == :r
      # ramp to value over time
      build += line(val, all[i+1], steps: all[i+2] * m)
      val = all[i+1]
      i = i + 3
    elsif all[i] == :a
      # append this array explicitly
      build += all[i+1]
      i = i + 2
    else
      raise "Error in envp when passing " + all.join(",") + " as list"
    end
  end
  return build
end

def clustered_sparse(d_micro, d_macro, div, mins)
  build = []
  
end


def pattern_and_shifts(notes,trans)
  build = []
  trans.each {|t| build = build + notes.map { |n| n + t } }
  return build
end

def pattern_and_shift_chords(chords,trans)
  build = []
  trans.each {|t| build = build + chords.map { |c| c.map { |n| n + t } } }
  return build
end



puts envp(1, :w, 0.5)
puts envp(1, :r, 0.5, 0.5)
puts envp(1, :j, 1, 0.5, :r, 0, 0.1,:w,1)

