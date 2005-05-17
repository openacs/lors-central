<if @clipboards:rowcount@ eq 1 and @this_item_clipped:rowcount@ eq 0 >
    <multiple name="clipboards">
       <if @displayed_object_id@ not nil>        
           <a href="@url@clipboards/attach?object_id=@displayed_object_id@&amp;clipboard_id=@clipboards.clipboard_id@">Clip this item
           </a>
        </if>
    </multiple>
</if>
<else>
    <if @displayed_object_id@ not nil>
        This item is in the clipboard
    </if>
</else>

<if @clipboards:rowcount@ gt 1>
    <p>Clip this item to</p>
    <form style="display: inline;" action="@url@clipboards/attach">
      <input type="hidden" name="object_id" value="@displayed_object_id@"></input>
      <select name="clipboard_id">
        <multiple name="clipboards">
          <option value="@clipboards.clipboard_id@" @clipboards.selected@>@clipboards.title@</option>
        </multiple>
      </select>
      <input type="submit" value="Go"></input>
    </form>
</if>

<if @items:rowcount@ gt 0>
    <p>Items in this clipboard:</p>
    <if @type@ eq "file">
       <listtemplate name="file_items"></listtemplate>
    </if>
    <else>
    <ul>
      <multiple name="items">
        <li style="padding: 4px;"> 
            <a href="/o/@items.object_id@">@items.item_title@</a>
	        <if @items.pretty_mime_type@ eq "">
		[@items.object_type@], clipped @items.clipped@ 
	        </if>	
	        <else>
		[@items.object_type@ "<i>@items.pretty_mime_type@</i>"], clipped @items.clipped@ 
                </else>
		<if @action_url@ not nil>
		   <a href="@action_url;noquote@&clipboard_object_id=@items.object_id@" class="button">@action_label@</a>
		</if> 
      <a href="/clipboard/remove?clipboard_id=@clipboard_id@&amp;object_id=@items.object_id@" class="button">remove</a></li>
      </multiple>
    </ul>
    </else>
</if>
<else>
    <p>#lors-central.there_are_no#</p>
</else>


<if @clipboards:rowcount@ gt 0>
    <p><a href="@url@clipboard/" class="button" title="#lors-central.view_all_exist#">#lors-central.view_all#</a></p>
</if>

</div>

