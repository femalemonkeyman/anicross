import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../../models/info_models.dart';
import '../aes_decrypt.dart';

const String zoro = "https://aniwatch.to/";

Provider zoroList(final AniData data) async {
  final List<MediaProv> episodes = [];
  try {
    final Map response = (await Dio().get(
      '$malsync/${data.malid}',
    ))
        .data;
    final Response html = await Dio().get(
      '${zoro}ajax/v2/episode/list/${response['Sites']['Zoro'].keys.first}',
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
    for (Element i in parse(jsonDecode(html.data)['html'])
        .getElementsByClassName('ssl-item  ep-item')) {
      episodes.add(
        MediaProv(
          provider: 'zoro',
          provId: i.attributes['data-id']!,
          title: i.attributes['title']!,
          number: i.attributes['data-number']!,
          call: () => zoroInfo(i.attributes['data-id']),
        ),
      );
    }
    return episodes;
  } catch (e) {
    print(e);
    return [];
  }
}

Anime zoroInfo(final id) async {
  print(id);
  final Options options = Options(responseType: ResponseType.plain);
  final Element server = parse(
    jsonDecode(
      (await Dio().get(
        '${zoro}ajax/v2/episode/servers?episodeId=$id',
        options: options,
      ))
          .data,
    )['html'],
  )
      .getElementsByClassName("item server-item")
      .firstWhere((element) => element.text.contains('Vid'));
  try {
    final Map link = jsonDecode(
      (await Dio().get(
        '${zoro}ajax/v2/episode/sources?id=${server.attributes['data-id']}',
        options: options,
      ))
          .data,
    );
    final Map<String, dynamic> sources = jsonDecode(
      (await Dio().get(
              'https://megacloud.tv/embed-2/ajax/e-1/getSources?id=${link['link'].split('e-1/')[1].split('?')[0]}',
              options: options))
          .data,
    );
    if (sources['encrypted']) {
      String key = '';
      int offset = 0;
      for (final List i in jsonDecode((await Dio().get(
              'https://raw.githubusercontent.com/enimax-anime/key/e6/key.txt'))
          .data)) {
        key += sources['sources'].substring(i.first - offset, i.last - offset);
        sources['sources'] = sources['sources'].toString().replaceRange(
              i.first - offset,
              i.last - offset,
              '',
            );
        offset += ((i.last as int) - (i.first as int));
      }
      sources['sources'] = jsonDecode(decrypt(sources['sources'], key));
    }
    sources['tracks'].removeWhere((element) => element['kind'] != 'captions');
    return Source(
      qualities: {
        'default': sources['sources'][0]['file'],
      },
      subtitles: {
        for (Map i in sources['tracks']) i['label']: i['file'],
      },
    );
  } catch (e) {
    print(e);
    return const Source(qualities: {}, subtitles: {});
  }
}
