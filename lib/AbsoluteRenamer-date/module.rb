module AbsoluteRenamer
    class DateModule < AbsoluteRenamer::IModule
        def initialize
            @filters = [
                pattern("(now)(:(.*))"),
                pattern("([acm]time)(:(.*))")
            ]

            @slash_replacement = conf[:options][:system_slash_replacement] || '-'
        end

        def interpret(file, infos, type)
            if infos[0].match(/now[:-]/)
                self.now(infos)
            elsif infos[0].match(/[acm]time[:-]/)
                self.time(file, infos)
            end
        end

        def now(infos)
            modifier = infos.delete_at(2)
            infos.compact!
            time = Time.now.strftime(infos[4])

            modify time, modifier
        end

        def time(file, infos)
            modifier = infos.delete_at(7)
            infos.compact!
            time = File.method(infos[2]).call(file.real_path)
            time = time.strftime(infos[4])

            modify time, modifier
        end
    end
end
