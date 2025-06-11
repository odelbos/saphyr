module Saphyr
  module Fields

    # The +IsoLang+ field type (ISO-639-1/2).
    #
    # Allowed options is: +:version with possible values: 1 or 2+
    #
    # - +1+ : Mean ISO-639-1 (default)
    # - +2+ : Mean ISO-639-2
    class IsoLangField < FieldBase
      PREFIX = 'iso-lang'
      EXPECTED_TYPES = String
      AUTHORIZED_OPTIONS = [:version]

      VERSION_1 = [
        'aa', 'ab', 'ae', 'af', 'ak', 'am', 'an', 'ar', 'as', 'av', 'ay', 'az',
        'ba', 'be', 'bg', 'bh', 'bi', 'bm', 'bn', 'bo', 'br', 'bs', 'ca', 'ce',
        'ch', 'co', 'cr', 'cs', 'cu', 'cv', 'cy', 'da', 'de', 'dv', 'dz', 'ee',
        'el', 'en', 'eo', 'es', 'et', 'eu', 'fa', 'ff', 'fi', 'fj', 'fo', 'fr',
        'fy', 'ga', 'gd', 'gl', 'gn', 'gu', 'gv', 'ha', 'he', 'hi', 'ho', 'hr',
        'ht', 'hu', 'hy', 'hz', 'ia', 'id', 'ie', 'ig', 'ii', 'ik', 'io', 'is',
        'it', 'iu', 'ja', 'jv', 'ka', 'kg', 'ki', 'kj', 'kk', 'kl', 'km', 'kn',
        'ko', 'kr', 'ks', 'ku', 'kv', 'kw', 'ky', 'la', 'lb', 'lg', 'li', 'ln',
        'lo', 'lt', 'lu', 'lv', 'mg', 'mh', 'mi', 'mk', 'ml', 'mn', 'mr', 'ms',
        'mt', 'my', 'na', 'nb', 'nd', 'ne', 'ng', 'nl', 'nn', 'no', 'nr', 'nv',
        'ny', 'oc', 'oj', 'om', 'or', 'os', 'pa', 'pi', 'pl', 'ps', 'pt', 'qu',
        'rm', 'rn', 'ro', 'ru', 'rw', 'sa', 'sc', 'sd', 'se', 'sg', 'si', 'sk',
        'sl', 'sm', 'sn', 'so', 'sq', 'sr', 'ss', 'st', 'su', 'sv', 'sw', 'ta',
        'te', 'tg', 'th', 'ti', 'tk', 'tl', 'tn', 'to', 'tr', 'ts', 'tt', 'tw',
        'ty', 'ug', 'uk', 'ur', 'uz', 've', 'vi', 'vo', 'wa', 'wo', 'xh', 'yi',
        'yo', 'za', 'zh', 'zu'
      ]

      VERSION_2 = [
        'aar', 'abk', 'ace', 'ach', 'ada', 'ady', 'afa', 'afh', 'afr', 'ain', 'aka',
        'akk', 'alb', 'ale', 'alg', 'alt', 'amh', 'ang', 'anp', 'apa', 'ara', 'arc',
        'arg', 'arm', 'arn', 'arp', 'art', 'arw', 'asm', 'ast', 'ath', 'aus', 'ava',
        'ave', 'awa', 'aym', 'aze', 'bad', 'bai', 'bak', 'bal', 'bam', 'ban', 'baq',
        'bas', 'bat', 'bej', 'bel', 'bem', 'ben', 'ber', 'bho', 'bih', 'bik', 'bin',
        'bis', 'bla', 'bnt', 'bos', 'bra', 'bre', 'btk', 'bua', 'bug', 'bul', 'bur',
        'byn', 'cad', 'cai', 'car', 'cat', 'cau', 'ceb', 'cel', 'cha', 'chb', 'che',
        'chg', 'chi', 'chk', 'chm', 'chn', 'cho', 'chp', 'chr', 'chu', 'chv', 'chy',
        'cmc', 'cnr', 'cop', 'cor', 'cos', 'cpe', 'cpf', 'cpp', 'cre', 'crh', 'crp',
        'csb', 'cus', 'cze', 'dak', 'dan', 'dar', 'day', 'del', 'den', 'dgr', 'din',
        'div', 'doi', 'dra', 'dsb', 'dua', 'dum', 'dut', 'dyu', 'dzo', 'efi', 'egy',
        'eka', 'elx', 'eng', 'enm', 'epo', 'est', 'ewe', 'ewo', 'fan', 'fao', 'fat',
        'fij', 'fil', 'fin', 'fiu', 'fon', 'fre', 'frm', 'fro', 'frr', 'frs', 'fry',
        'ful', 'fur', 'gaa', 'gay', 'gba', 'gem', 'geo', 'ger', 'gez', 'gil', 'gla',
        'gle', 'glg', 'glv', 'gmh', 'goh', 'gon', 'gor', 'got', 'grb', 'grc', 'gre',
        'grn', 'gsw', 'guj', 'gwi', 'hai', 'hat', 'hau', 'haw', 'heb', 'her', 'hil',
        'him', 'hin', 'hit', 'hmn', 'hmo', 'hrv', 'hsb', 'hun', 'hup', 'iba', 'ibo',
        'ice', 'ido', 'iii', 'ijo', 'iku', 'ile', 'ilo', 'ina', 'inc', 'ind', 'ine',
        'inh', 'ipk', 'ira', 'iro', 'ita', 'jav', 'jbo', 'jpn', 'jpr', 'jrb', 'kaa',
        'kab', 'kac', 'kal', 'kam', 'kan', 'kar', 'kas', 'kau', 'kaw', 'kaz', 'kbd',
        'kha', 'khi', 'khm', 'kho', 'kik', 'kin', 'kir', 'kmb', 'kok', 'kom', 'kon',
        'kor', 'kos', 'kpe', 'krc', 'krl', 'kro', 'kru', 'kua', 'kum', 'kur', 'kut',
        'lad', 'lah', 'lam', 'lao', 'lat', 'lav', 'lez', 'lim', 'lin', 'lit', 'lol',
        'loz', 'ltz', 'lua', 'lub', 'lug', 'lui', 'lun', 'luo', 'lus', 'mac', 'mad',
        'mag', 'mah', 'mai', 'mak', 'mal', 'man', 'mao', 'map', 'mar', 'mas', 'may',
        'mdf', 'mdr', 'men', 'mga', 'mic', 'min', 'mis', 'mkh', 'mlg', 'mlt', 'mnc',
        'mni', 'mno', 'moh', 'mon', 'mos', 'mul', 'mun', 'mus', 'mwl', 'mwr', 'myn',
        'myv', 'nah', 'nai', 'nap', 'nau', 'nav', 'nbl', 'nde', 'ndo', 'nds', 'nep',
        'new', 'nia', 'nic', 'niu', 'nno', 'nob', 'nog', 'non', 'nor', 'nqo', 'nso',
        'nub', 'nwc', 'nya', 'nym', 'nyn', 'nyo', 'nzi', 'oci', 'oji', 'ori', 'orm',
        'osa', 'oss', 'ota', 'oto', 'paa', 'pag', 'pal', 'pam', 'pan', 'pap', 'pau',
        'peo', 'per', 'phi', 'phn', 'pli', 'pol', 'pon', 'por', 'pra', 'pro', 'pus',
        'qaa', 'que', 'raj', 'rap', 'rar', 'roa', 'roh', 'rom', 'rum', 'run', 'rup',
        'rus', 'sad', 'sag', 'sah', 'sai', 'sal', 'sam', 'san', 'sas', 'sat', 'scn',
        'sco', 'sel', 'sem', 'sga', 'sgn', 'shn', 'sid', 'sin', 'sio', 'sit', 'sla',
        'slo', 'slv', 'sma', 'sme', 'smi', 'smj', 'smn', 'smo', 'sms', 'sna', 'snd',
        'snk', 'sog', 'som', 'son', 'sot', 'spa', 'srd', 'srn', 'srp', 'srr', 'ssa',
        'ssw', 'suk', 'sun', 'sus', 'sux', 'swa', 'swe', 'syc', 'syr', 'tah', 'tai',
        'tam', 'tat', 'tel', 'tem', 'ter', 'tet', 'tgk', 'tgl', 'tha', 'tib', 'tig',
        'tir', 'tiv', 'tkl', 'tlh', 'tli', 'tmh', 'tog', 'ton', 'tpi', 'tsi', 'tsn',
        'tso', 'tuk', 'tum', 'tup', 'tur', 'tut', 'tvl', 'twi', 'tyv', 'udm', 'uga',
        'uig', 'ukr', 'umb', 'und', 'urd', 'uzb', 'vai', 'ven', 'vie', 'vol', 'vot',
        'wak', 'wal', 'war', 'was', 'wel', 'wen', 'wln', 'wol', 'xal', 'xho', 'yao',
        'yap', 'yid', 'yor', 'ypk', 'zap', 'zbl', 'zen', 'zgh', 'zha', 'znd', 'zul',
        'zun', 'zxx', 'zza'
      ]

      def initialize(opts={})
        if opts[:version].nil?
          opts[:version] = 1
        else
          if opts[:version] != 1 and opts[:version] != 2
            raise Saphyr::Error.new 'Bad language akpha option must be : 2 or 3'
          end
        end
        super opts
      end

      private

        def do_validate(ctx, name, value, errors)
          if value.empty?
            add_error value, errors
            return
          end

          if @opts[:version] == 1
            add_error value, errors unless VERSION_1.include? value
          else
            add_error value, errors unless VERSION_2.include? value
          end
        end

        def add_error(value, errors)
          errors << {
            type: err('invalid'),
            data: {
              _val: value
            }
          }
        end
    end
  end
end
