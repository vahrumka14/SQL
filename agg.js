/*'ФИО: Мироненко Елена Борисовна'*/


/*--Домашнее задание №4*/

/*
        подсчитайте число элементов в созданной коллекции tags в bd movies
*/

print("tags count: ", db.tags.count());


/*
        подсчитайте число фильмов с конкретным тегом - woman
*/


print("woman tags count: ", db.tags.find({name: 'woman'}).count());


/*
        используя группировку данных ($groupby) вывести top-3 самых распространённых тегов
*/

/*db.tags.aggregate([{$group: {_id: "$name", tag_count: { $sum: 1 }}}, {$sort:{"tag_count":-1}}, {$limit:3}])*/

/*для версии mongo 3.0.15*/

var d= db.tags.aggregate([{$group: {_id: "$name", tag_count: { $sum: 1 }}}, {$sort:{"tag_count":-1}}, {$limit:3}]);
while(d.hasNext()){
    printjson(d.next());
}

/*printjson(
        db.tags.aggregate([
                {$group: {
                                _id: "$name",
                                tag_count: { $sum: 1 }
                           }
                },
                {$sort:{"tag_count":-1}},
                {$limit: 3}
        ])
);*/

/*/usr/bin/mongo $APP_MONGO_HOST:$APP_MONGO_PORT/movies /home/lena/Netology/SQL/agg.js*/





