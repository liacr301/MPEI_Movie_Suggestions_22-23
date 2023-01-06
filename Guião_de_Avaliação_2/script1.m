user_data = load("u.data");
data = user_data(1:end,1:3); %id_user, id_movie, rating
clear user_data;

users = unique(data(:,1)); %ir buscar users
num_users = length(users);

dic = readcell('films.txt', 'Delimiter', '\t');
num_movies = height(dic);

% this is working - used in option 1
%get movies from each user
movies = cell(num_users,1);
for n = 1:num_users
    ind = find(data(:,1) == users(n)); %vai buscar todos os filmes com o user n
    movies{n} = [movies{n} data(ind,2)];% adiciona filmes encontrados ao cellarray no indice n
end

% option 2 - minHash da aula 11 - this is working
num_hash = 100; 

minHashTableUsers=inf(num_users,num_hash);                                                  
for i=1:num_users
   movies_user=movies{i};                                                           
   for j=1:length(movies_user) 
       key=char(movies_user(j));
       for k=1:num_hash
            key = [key num2str(k)];                                         
            h(k)= DJB31MA( key, 127);                                        
       end
       minHashTableUsers(i,:)=min([minHashTableUsers(i,:);h]);                             %menor assinatura pois há menos colisões e tem menos falsos positivos
   end
end


%option 3

%get genres
genres = cell(num_movies,1);
for i= 1:height(dic)
    for j = 2:7
        if ischar(dic{i,j})
            genres{i} = dic{i,j};
        end
    end
end

single_genres = unique(genres);
num_genres = length(single_genres);

%matrix minhash of genres

minHashTableGenres=inf(num_movies,num_hash); %tamanho
shingSize = 3;
for i=1:num_movies 
   genre=genres{i};
   for j=1:length(genre)-shingSize+1
       key=lower(genre(j:j+shingSize-1));
       h=zeros(1,num_hash);
       for k=1:num_hash
            key=[key num2str(k)];
            h(k)= DJB31MA( key, 127);
       end
       minHashTableGenres(i,:)=min([minHashTableGenres(i,:);h]);
   end
end
 
%distances of genres
distances_genres = zeros(num_genres,num_genres); 
for n1= 1:num_genres
    for n2= n1+1:num_genres
        distances_genres(n1,n2) = sum(minHashTableGenres(:,n1)==minHashTableGenres(:,n2))/num_hash;
    end
end

% option 4

titles = dic(:,1);
num_titles = length(titles);
minHashTableTitles = inf(num_titles, num_hash);

for i = 1:num_titles
    movie_title = titles{i};
    for j = 1 : (length(movie_title) - shingSize +1)
        shingle = lower(char(movie_title(j:(j+shingSize-1))));
        h = zeros(1, num_hash);
        for k = 1:num_hash
            shingle = [shingle num2str(k)];
            h(k) = DJB31MA(shingle, 127);
        end
    minHashTableTitles(i, :) = min([minHashTableTitles(i, :); h]);
    end
end

distances_titles = zeros(num_titles,num_titles);
for n1= 1:num_titles
    for n2= n1+1:num_titles
        distances_titles(n1,n2) = sum(minHashTableTitles(n1,:)==minHashTableTitles(n2,:))/num_hash;
    end
end

save movies genres titles minHashTableUsers minHashTableGenres distances_genres minHashTableTitles distances_titles

% hash function
function h= DJB31MA(key, seed)
    len= length(key);
    key= double(key);
    h= seed;
    for i=1:len
        h = mod(31 * h + key(i), 2^32 -1) ;
    end
end
