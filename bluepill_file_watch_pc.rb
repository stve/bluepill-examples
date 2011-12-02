# gist: http://gist.github.com/390596

Bluepill.define_process_condition(:log_watch) do

  def initialize(options = {})
    @file_name = options.delete(:file)
    @regexp = options.delete(:regexp)
    @file_pos = 0
    @file_size = 0
  end

  def run(pid)
    File.open(@file_name, "r") do |file|
      @file_size = file.stat.size
      @file_pos = 0 if @file_size < @file_pos # file truncated
      file.seek @file_pos, IO::SEEK_SET
      @file_pos = @file_size # grep will seek to end
      file.grep(@regexp)
    end
  end

  def check(value)
    value.empty?
  end

end


# --------------------

process.checks :log_watch, :file => "file.log", :regexp => /ErrorXPTO/, :every => 60