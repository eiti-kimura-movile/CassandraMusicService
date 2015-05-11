package com.example.cassandra.music;

import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.Host;
import com.datastax.driver.core.Metadata;
import com.datastax.driver.core.ResultSet;
import com.datastax.driver.core.Row;
import com.datastax.driver.core.Session;

/**
 * simple demo program that ilustrates a datastax java driver cassandra
 * connection
 * 
 * @author eitikimura
 */
public class SimpleClient {

	/**
	 * the object representing the cluster
	 */
	private Cluster cluster;

	/**
	 * a connected session to the cluster
	 */
	private Session session;

	/**
	 * the connect method
	 * 
	 * @param node
	 *            the contact point
	 */
	public void connect(String node) {

		cluster = Cluster.builder().addContactPoint(node).build();

		// get some cluster meta data
		Metadata metadata = cluster.getMetadata();
		System.out.printf("Connected to cluster: %s\n",
				metadata.getClusterName());

		for (Host host : metadata.getAllHosts()) {
			System.out.printf("Datatacenter: %s; Host: %s; Rack: %s\n",
					host.getDatacenter(), host.getAddress(), host.getRack());
		}

		// retrieve a connected session
		session = cluster.connect();
	}

	public Session getSession() {
		return session;
	}

	public void close() {
		session.close();
		cluster.close();
	}

	public static void main(String[] args) {

		// System.setProperty("org.slf4j.simpleLogger.defaultLogLevel", "INFO");

		SimpleClient client = new SimpleClient();
		client.connect("127.0.0.1");

		Session session = client.getSession();

		ResultSet results = session.execute("SELECT * FROM music.playlists");
		for (Row row : results.all()) {
			print(row);
		}
		sleep(3);

		client.close();
	}

	/**
	 * just prints the row information
	 * 
	 * @param row
	 *            the Cassandra row object
	 */
	public static void print(Row row) {
		System.out.println(String.format(
				"id:%-3s\t title: %-30s\t album:%-20s\t artist:%-20s \t%-10s",
				row.getString("id"), row.getString("title"),
				row.getString("album"), row.getString("artist"),
				row.getSet("tags", String.class)));
	}

	/**
	 * just sleep some time
	 * 
	 * @param time
	 *            amount of time in secs
	 */
	public static void sleep(int time) {
		try {
			Thread.sleep(time * 1000);
		} catch (InterruptedException e) {
			// do nothing
		}
	}
}