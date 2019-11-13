### Набор данных: теги Danbooru vs сущности Myanimelist (CSV через ;)

Содержит теги https://danbooru.donmai.us/ **(NSFW !!!)** типов Copyrights (3) и Characters (4) встречающиеся 5 и более раз
в датасете Danbooru2018, сгруппированные и совмещенные с anime и character сущностями https://myanimelist.net/

- TAG_CAT категория тега 3 = Copyrights (произведения, студии, торговые марки и что попало) 4 = Characters (персонажи)
- TAG_ID внутренний номер тега в Danbooru, удобен как уникальный связующий ключ 
- TAG_NAME собственно текстовый поисковый тег https://danbooru.donmai.us/posts?tags=patchouli_knowledge
- TAG_CNT количество использований в Danbooru2018, дает представление о популярности тега
- FR_ID код "**франшизы** = группы Copyrights с преимущественно общими Characters"
  в качестве франшизы выбирается одно из произведений - хронологически первое, самое популярное или как карта ляжет
- MAL_ID код персонажа https://myanimelist.net/character/9909 или произведения https://myanimelist.net/anime/9874
- MAL_NAME имя сущности на myanimelist
- MAL_CNT количество фаворитов на myanimelist, дает представление о популярности сущности

#### SQL create table (Oracle syntax)
```
create table danbooru_taglist (
TAG_CAT number(1) not null,
TAG_ID number(7) not null,
TAG_NAME varchar2(400) not null,
TAG_CNT number(6) not null,
FR_ID number(7),
MAL_ID number(6),
MAL_NAME varchar2(400) not null,
MAL_CNT number(6) )
```

